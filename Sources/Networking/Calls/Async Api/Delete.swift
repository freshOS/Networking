//
//  Delete.swift
//
//
//  Created by Sacha Durand Saint Omer on 12/11/2023.
//

import Foundation

public extension NetworkingClient {
    
    func delete(_ route: String) async throws {
        let _:Data = try await delete(route)
    }
    
    func delete<T: Decodable>(_ route: String,
                           keypath: String? = nil) async throws -> T {
        let json: Any = try await delete(route)
        return try self.toModel(json, keypath: keypath)
    }
    
    func delete<T: Decodable>(_ route: String,
                           keypath: String? = nil) async throws -> T where T: Collection {
        let keypath = keypath ?? defaultCollectionParsingKeyPath
        let json: Any = try await delete(route)
        return try self.toModel(json, keypath: keypath)
    }

    func delete(_ route: String) async throws -> Any {
        let data: Data = try await delete(route)
        return try JSONSerialization.jsonObject(with: data, options: [])
    }
    
    func delete(_ route: String) async throws -> Data {
        try await request(.delete, route).execute()
    }
}
