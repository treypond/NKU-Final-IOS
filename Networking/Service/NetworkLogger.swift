//
//  NetworkLogger.swift
//  Marvel
//
//  Created by Adam Linkhart on 7/6/21.
//

import Foundation

class NetworkLogger {
    static func log(request: URLRequest) {
        
        print ("\n - - - - - - - - - -  OUTGOING - - - - - - - - - - \n")
        defer { print("\n - - - - - - - - - - END - - - - - - - - - - \n")}
        
        let urlAsString = request.url?.absoluteString ?? ""
        let urlComponents = URLComponents(string: urlAsString)
        
        let method = request.httpMethod != nil ? "\(request.httpMethod ?? "")" : ""
        let path = "\(urlComponents?.path ?? "")"
        let query = "\(urlComponents?.query ?? "")"
        let host = "\(urlComponents?.host ?? "")"
        
        var logOutput = """
                        \(urlAsString) \n\n
                        \(method) \(path)?\(query) HTTP/1.1 \n
                        HOST: \(host)\n
                        """
        
        for (key, value) in request.allHTTPHeaderFields ?? [:] {
            logOutput += "\(key): \(value) \n"
        }
        
        if let body = request.httpBody {
            logOutput += "\n \(String(data: body, encoding: String.Encoding.utf8) ?? "")"
        }
        
        print(logOutput)
    }
    
    static func log(response: URLResponse) {}
}
