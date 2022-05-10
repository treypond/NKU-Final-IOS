//
//  NetworkManager.swift
//  Marvel
//
//  Created by Adam Linkhart on 7/6/21.
//

import Foundation
import CryptoKit

enum NetworkResponse: String {
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode"
    case unableToDecode = "We could not decode the response."
}

enum Result<String> {
    case success
    case failure(String)
}

struct NetworkManager {
    static let environment: NetworkEnvironment = .production
    static let privateKey = "7f789e9722388bcadd91af7bcf661fefa6591d28"
    static let publicKey = "122681ba92f6f57f2e3244cd9937acb0"
    static let timestamp = "\(Date().timeIntervalSince1970)"
    static let hash = "\(timestamp)\(privateKey)\(publicKey)".MD5
    let router = Router<MarvelApi>()
    
    func getCharacters(offset: Int, limit: Int, completion: @escaping (_ container: MarvelCharacterContainer?, _ error: String?) -> ()) {
        router.request(.characters(offset: offset, limit: limit)) { data, response, error in
            
            if error != nil {
                completion(nil, "Please check your network connection.")
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        print(responseData)
                        let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                        print(jsonData)
                        let characterDataWrapper = try JSONDecoder().decode(MarvelCharacterDataWrapper.self, from: responseData)
                        
                        
                        guard let container = characterDataWrapper.data else {
                            completion(nil, NetworkResponse.unableToDecode.rawValue)
                            return
                        }
                        completion(container, nil)
                    } catch {
                        print(error)
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String> {
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
}

//typealias CharacterDataWrapperCompletionResult = ((Result<MarvelCharacterDataWrapper, NSError>) -> Void)

//class NetworkManager: ObservableObject {
//
//    let publicKey = "122681ba92f6f57f2e3244cd9937acb0"
//    let privateKey = "7f789e9722388bcadd91af7bcf661fefa6591d28"
//    let timestamp: String
//    let hash: String
//    let baseURL = URL(string: "https://gateway.marvel.com:443v1/public/characters")
//
//    @Published var characters = [MarvelCharacter]()
//
//    init() {
//        timestamp = "\(Date().timeIntervalSince1970)"
//        hash = "\(timestamp)\(privateKey)\(publicKey)".md5
//
//        getCharacters()
//    }
//
//    func getCharacters() {
//
//        var components = URLComponents(url: (baseURL?.appendingPathComponent("v1/public/characters"))!, resolvingAgainstBaseURL: true)
//
//        let commonQueryItems = [
//                    URLQueryItem(name: "ts", value: timestamp),
//                    URLQueryItem(name: "hash", value: hash),
//                    URLQueryItem(name: "apikey", value: publicKey)
//                ]
//
//        guard let url = components?.url else {
//            return
//        }
//
//        URLSession.shared.dataTask(with: url) { (data, response, error) in
//            if let error = error {
//                return
//            }
//
//            guard let data = data else {
//                return
//            }
//
//            guard let characterWrapper = try? JSONDecoder().decode(MarvelCharacterDataWrapper.self, from: data) else {
//                return
//            }
//
//            guard let characters = characterWrapper.data?.characters else {
//                return
//            }
//
//            self.characters = characters
//
//            return
//        }.resume()
//    }
//
//}

extension String {
    
    var MD5: String {
        let computed = Insecure.MD5.hash(data: self.data(using: .utf8)!)
        return computed.map { String(format: "%02hhx", $0) }.joined()
    }
}

