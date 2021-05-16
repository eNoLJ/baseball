//
//  OAuthManager.swift
//  baseball
//
//  Created by Issac on 2021/05/10.
//

import Foundation
import OctoKit
import AuthenticationServices
import Combine

class OAuthManager {
    let networkingCenter: ServerCommunicable
    var errorHandler: ((String) -> ())?
    var cancelable = Set<AnyCancellable>()
    lazy var config = OAuthConfiguration.init(token: self.getClientID(),
                                              secret: "",
                                              scopes: ["user"])
    
    init(serverCommunicable: ServerCommunicable) {
        self.networkingCenter = serverCommunicable
    }
    
    func initPostLoginCodeWebAuthSession(completion: @escaping (UserDTO) -> ()) -> ASWebAuthenticationSession? {
        let callbackUrlScheme = "baseball"
        guard let url = config.authenticate()?.appending([URLQueryItem(name: "redirect_uri", value: "baseball://")]) else { return nil }
        return ASWebAuthenticationSession.init(url: url, callbackURLScheme: callbackUrlScheme, completionHandler: { (callBack:URL?, error:Error?) in
            if error != nil {
                self.errorHandler?(NetworkingError.ASWebAuthenticationSessionError.rawValue)
                return
            }
            guard let successURL = callBack else { return }
            let callBackURLCode = successURL.extractCallbackURLCode()
            
            guard let url = Endpoint.url(path: .login, callBackUrlCode: callBackURLCode) else { return }
            let publisher: AnyPublisher<UserDTO, Error> = self.networkingCenter.request(url: url, path: Path.login, token: nil)
            publisher.sink { (completion) in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorHandler?(error.localizedDescription)
                }
            } receiveValue: { (userDTO) in
                completion(userDTO)
            }.store(in: &self.cancelable)
        })
    }
}

extension OAuthManager {
    func getClientID() -> String {
        guard let path = Bundle.main.path(forResource: "NetworkElements", ofType: "plist") else { return "" }
        let plist = NSDictionary(contentsOfFile: path)
        guard let key = plist?.object(forKey: "ClientID") as? String else { return "" }
        return key
    }
}
