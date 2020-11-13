//
//  NetworkingLogger.swift
//  
//
//  Created by Sacha on 13/03/2020.
//

import Foundation

class NetworkingLogger {

    var logLevels = NetworkingLogLevel.off

    func log(request: URLRequest) {
        guard logLevels != .off else {
            return
        }
        if let verb = request.httpMethod,
            let url = request.url {
            print("\(verb) '\(url.absoluteString)'")
            logHeaders(request)
            logBody(request)
        }
    }

    func log(response: URLResponse, data: Data) {
        guard logLevels != .off else {
            return
        }
        if let response = response as? HTTPURLResponse {
            logStatusCodeAndURL(response)
        }
        if logLevels == .debug {
            if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers),
               let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
                print(String(decoding: jsonData, as: UTF8.self))
            } else {
                print(String(decoding: data, as: UTF8.self))
            }
        }
    }

    private func logHeaders(_ urlRequest: URLRequest) {
        if let allHTTPHeaderFields = urlRequest.allHTTPHeaderFields {
            for (key, value) in allHTTPHeaderFields {
                print("  \(key) : \(value)")
            }
        }
    }

    private func logBody(_ urlRequest: URLRequest) {
        if let body = urlRequest.httpBody,
            let str = String(data: body, encoding: .utf8) {
            print("  HttpBody : \(str)")
        }
    }

    private func logStatusCodeAndURL(_ urlResponse: HTTPURLResponse) {
        if let url = urlResponse.url {
            print("\(urlResponse.statusCode) '\(url.absoluteString)'")
        }
    }
}
