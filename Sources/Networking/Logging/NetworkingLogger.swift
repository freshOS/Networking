//
//  NetworkingLogger.swift
//
//
//  Created by Sacha on 13/03/2020.
//

import Foundation

class NetworkingLogger {

    var logLevel = NetworkingLogLevel.off

    func log(request: URLRequest) {
        guard logLevel != .off else {
            return
        }
        if let verb = request.httpMethod,
            let url = request.url {
            print("\(verb) '\(url.absoluteString)'")
            logHeaders(request)
            logBody(request)

        }
        if logLevel == .debug {
            logCurl(request)
        }
    }

    func log(response: URLResponse, data: Data) {
        guard logLevel != .off else {
            return
        }
        if let response = response as? HTTPURLResponse {
            logStatusCodeAndURL(response)
        }
        if logLevel == .debug {
            print(String(decoding: data, as: UTF8.self))
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
    
    private func logCurl(_ urlRequest: URLRequest) {
        print(urlRequest.toCurlCommand())
    }
}

extension URLRequest {

    /**
        Heavily inspired from : https://gist.github.com/shaps80/ba6a1e2d477af0383e8f19b87f53661d
     */
    public func toCurlCommand() -> String {
        guard let url = url else { return "" }
        var command = ["curl \"\(url.absoluteString)\""]

        if let method = httpMethod, method != "GET" && method != "HEAD" {
            command.append("-X \(method)")
        }

        allHTTPHeaderFields?
            .filter { $0.key != "Cookie" }
            .forEach { command.append("-H '\($0.key): \($0.value)'")}

        if let data = httpBody, let body = String(data: data, encoding: .utf8) {
            command.append("-d '\(body)'")
        }

        return command.joined(separator: " \\\n\t")
    }

}
