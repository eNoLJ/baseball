//
//  Endpoint.swift
//  baseball
//
//  Created by Issac on 2021/05/10.
//

import Foundation

public enum Path: String {
    case login
    case logout
    case memberList
    case gameList = "games"
    case gameStart
    case gamePlaying
    case gameScore = "games/scores"
    case playerScore
    
    enum HTTPMethod: String {
        case GET
        case POST
        case PATCH
    }
    
    var needHTTPMethod: HTTPMethod {
        switch self {
        case .login: return .POST
        case .gamePlaying: return .PATCH
        default: return .GET
        }
    }
}

public enum Endpoint {
    private static let scheme = "http"
    private static let host = getHost()
    private static let port = 8080
    
    static func url(path : Path, parameter: String = "", callBackUrlCode: String = "") -> URL? {
        let components: URLComponents = {
            var components = URLComponents()
            components.scheme = scheme
            components.host = host
            components.port = port
            components.queryItems = path == .login ? [URLQueryItem(name: "code", value: callBackUrlCode)] : nil
            components.path = {
                switch path {
                case .memberList: return "/members/\(parameter)"
                case .gameStart: return "/games/\(parameter)"
                case .playerScore: return "/games/scores/\(parameter)"
                default: return "/\(path.rawValue)"
                }
            }()
            return components
        }()
        return components.url
    }
    
    static func getHost() -> String {
        guard let path = Bundle.main.path(forResource: "NetworkElements", ofType: "plist") else { return "" }
        let plist = NSDictionary(contentsOfFile: path)
        guard let key = plist?.object(forKey: "Host") as? String else { return "" }
        return key
    }
}


