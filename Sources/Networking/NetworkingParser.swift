//
//  NetworkingParser.swift
//
//
//  Created by Sacha on 13/03/2020.
//

import Foundation


public struct NetworkingParser {

    public init() {}

    public func toModel<T: NetworkingJSONDecodable>(_ json: Any, keypath: String? = nil) throws -> T {
        do {
            let data = resourceData(from: json, keypath: keypath)
            return try T.decode(data)
        } catch (let error) {
            throw error
        }
    }

    public func toModels<T: NetworkingJSONDecodable>(_ json: Any, keypath: String? = nil) throws -> [T] {
        do {
            guard let array = resourceData(from: json, keypath: keypath) as? [Any] else {
                return [T]()
            }
            return try array.map {
                try T.decode($0)
            }.compactMap { $0 }
        } catch (let error) {
            throw error
        }
    }

    private func resourceData(from json: Any, keypath: String?) -> Any {
        if let keypath = keypath, !keypath.isEmpty, let dic = json as? [String: Any], let val = dic[keypath] {
            return val is NSNull ? json : val
        }
        return json
    }
}
