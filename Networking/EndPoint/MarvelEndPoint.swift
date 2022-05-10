//
//  MarvelEndPoint.swift
//  Marvel
//
//  Created by Adam Linkhart on 7/6/21.
//

import Foundation

enum NetworkEnvironment {
    case development
    case production
    case stage
}

public enum MarvelApi {
    case characters(offset: Int, limit: Int)
}

extension MarvelApi: EndPointType {
    
    var environmentBaseURL: String {
        switch NetworkManager.environment {
        case .development: return ""
        case .production: return "https://gateway.marvel.com:443/v1/public"
        case .stage: return ""
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else {
            fatalError("baseURL could not be configured.")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .characters(_,_):
            return "/characters"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        switch self {
        case .characters(let offset, let limit):
            return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: ["apikey":NetworkManager.publicKey, "ts":NetworkManager.timestamp, "hash":NetworkManager.hash, "offset":offset, "limit":limit])
        default:
            return .request
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}
