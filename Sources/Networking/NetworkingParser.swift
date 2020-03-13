//
//  File.swift
//  
//
//  Created by Sacha on 13/03/2020.
//

import Foundation

public struct NetworkingParser {
    
    public init() {}

    public func toModel<T: NetworkingJSONDecodable>(_ json: Any, keypath: String? = nil) throws -> T {
        let data = resourceData(from: json, keypath: keypath)
        guard let r: T = resource(from: data) else {
            throw NetworkingError.unableToParseResponse
        }
        return r
    }

    public func toModels<T: NetworkingJSONDecodable>(_ json: Any, keypath: String? = nil) -> [T] {
        guard let array = resourceData(from: json, keypath: keypath) as? [Any] else {
            return [T]()
        }
        return array.map {
            resource(from: $0)
        }.compactMap { $0 }
    }

    private func resource<T: NetworkingJSONDecodable>(from json: Any) -> T? {
        return try? T.decode(json)
    }

    private func resourceData(from json: Any, keypath: String?) -> Any {
        if let k = keypath, !k.isEmpty,  let dic = json as? [String: Any], let j = dic[k] {
            return j
        }
        return json
    }
}
