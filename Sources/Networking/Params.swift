//
//  Params.swift
//  
//
//  Created by Sacha on 13/03/2020.
//

import Foundation

public typealias Params = [String: CustomStringConvertible]
    
extension Params {
    public func asPercentEncodedString(parentKey: String? = nil) -> String {
        return self.map { key, value in
            var escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            if let `parentKey` = parentKey {
                escapedKey = "\(parentKey)[\(escapedKey)]"
            }

            if let dict = value as? Params {
                return dict.asPercentEncodedString(parentKey: escapedKey)
            } else if let array = value as? [CustomStringConvertible] {
                return array.map { entry in
                    let escapedValue = "\(entry)"
                        .addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
                    return "\(escapedKey)[]=\(escapedValue)"
                }.joined(separator: "&")
            } else {
                let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
                return "\(escapedKey)=\(escapedValue)"
            }
        }
        .joined(separator: "&")
    }
}
