//
//  URLRequest+cURL.swift
//  
//
//  Created by Sacha DSO on 14/04/2022.
//

import Foundation

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
