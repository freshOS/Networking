//
//  Get.swift
//
//
//  Created by Sacha Durand Saint Omer on 12/11/2023.
//

import Foundation

public extension NetworkingClient {
    
    func get(_ route: String, urlParams: Params? = nil) async throws {
        let _:Data = try await get(route, urlParams: urlParams)
    }
    
    func get<T: Decodable>(_ route: String,
                           urlParams: Params? = nil,
                           keypath: String? = nil) async throws -> T {
        let json: Any = try await get(route, urlParams: urlParams)
        return try self.toModel(json, keypath: keypath)
    }
    
    func get<T: Decodable>(_ route: String,
                           urlParams: Params? = nil,
                           keypath: String? = nil) async throws -> T where T: Collection {
        let keypath = keypath ?? defaultCollectionParsingKeyPath
        let json: Any = try await get(route, urlParams: urlParams)
        return try self.toModel(json, keypath: keypath)
    }
    
    func get(_ route: String, urlParams: Params? = nil) async throws -> Any {
        let data: Data = try await get(route, urlParams: urlParams)
        return try JSONSerialization.jsonObject(with: data, options: [])
    }
    
    func get(_ route: String, urlParams: Params? = nil) async throws -> Data {
        try await request(.get, route, urlParams: urlParams).execute()
    }
}
