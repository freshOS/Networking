//
//  Get.swift
//
//
//  Created by Sacha Durand Saint Omer on 12/11/2023.
//

import Foundation

public extension NetworkingClient {
    
    func get(_ route: String, params: Params? = nil) async throws {
        let _:Data = try await get(route, params: params)
    }
    
    func get<T: Decodable>(_ route: String,
                           params: Params? = nil,
                           keypath: String? = nil) async throws -> T {
        let json: Any = try await get(route, params: params)
        return try self.toModel(json, keypath: keypath)
    }
    
    func get<T: Decodable>(_ route: String,
                           params: Params? = nil,
                           keypath: String? = nil) async throws -> T where T: Collection {
        let keypath = keypath ?? defaultCollectionParsingKeyPath
        let json: Any = try await get(route, params: params)
        return try self.toModel(json, keypath: keypath)
    }
    
    func get(_ route: String, params: Params? = nil) async throws -> Any {
        let data: Data = try await get(route, params: params)
        return try JSONSerialization.jsonObject(with: data, options: [])
    }
    
    func get(_ route: String, params: Params? = nil) async throws -> Data {
        try await request(.get, route, params: params).execute()
    }
}

public extension NetworkingService {
    
    func get(_ route: String, params: Params? = nil) async throws {
        return try await network.get(route, params: params)
    }
    
    func get<T: Decodable>(_ route: String,
                           params: Params? = nil,
                           keypath: String? = nil) async throws -> T {
        try await network.get(route, params: params, keypath: keypath)
    }
    
    func get<T: Decodable>(_ route: String,
                           params: Params? = nil,
                           keypath: String? = nil) async throws -> T where T: Collection {
        try await network.get(route, params: params, keypath: keypath)
    }
    
    
    func get(_ route: String, params: Params? = nil) async throws -> Any {
        try await network.get(route, params: params)
    }
    
    func get(_ route: String, params: Params? = nil) async throws -> Data {
        try await network.get(route, params: params)
    }
}
