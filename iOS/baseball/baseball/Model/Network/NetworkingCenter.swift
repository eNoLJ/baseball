//
//  NetworkingCenter.swift
//  baseball
//
//  Created by Issac on 2021/05/06.
//

import Foundation
import Combine

protocol ServerCommunicable {
    func request<T: Decodable>(url: URL, path: Path, token: String?) -> AnyPublisher<T, Error>
}

final class NetworkingCenter: ServerCommunicable {
    func request<T: Decodable>(url: URL, path: Path, token: String? = nil) -> AnyPublisher<T, Error> {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = path.needHTTPMethod.rawValue
        if let token = token {
            urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

extension NetworkingCenter {
    private func getHOST() -> String {
        guard let path = Bundle.main.path(forResource: "NetworkElements", ofType: "plist") else { return "" }
        let plist = NSDictionary(contentsOfFile: path)
        guard let key = plist?.object(forKey: "Host") as? String else { return "" }
        return key
    }
    
    private func handleError(data: Data?, response: URLResponse?, error: Error?) -> NetworkingError? {
        if let error = error as NSError?, error.domain == NSURLErrorDomain, error.code == NSURLErrorNotConnectedToInternet {
            return NetworkingError.notConnectedToInternet
        }
        
        guard let httpResponse = response as? HTTPURLResponse, data != nil else {
            return NetworkingError.networkError
        }
        guard 200..<300 ~= httpResponse.statusCode else {
            #if DEBUG
            NSLog("\(httpResponse.statusCode)")
            #endif
            return NetworkingError.responseError
        }
        return nil
    }
}
