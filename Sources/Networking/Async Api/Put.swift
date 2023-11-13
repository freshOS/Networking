//
//  Put.swift
//
//
//  Created by Sacha Durand Saint Omer on 12/11/2023.
//

import Foundation

public extension NetworkingClient {
    
    func put(_ route: String, body: HTTPBody? = nil) async throws {
        let _: Data = try await put(route, body: body)
    }
    
    func put<T: Decodable>(_ route: String,
                           body: HTTPBody? = nil,
                           keypath: String? = nil) async throws -> T {
        let json: Any = try await put(route, body: body)
        return try self.toModel(json, keypath: keypath)
    }
    
    func put<T: Decodable>(_ route: String,
                           body: HTTPBody? = nil,
                           keypath: String? = nil) async throws -> T where T: Collection {
        let keypath = keypath ?? defaultCollectionParsingKeyPath
        let json: Any = try await put(route, body: body)
        return try self.toModel(json, keypath: keypath)
    }
    
    func put(_ route: String, body: HTTPBody? = nil) async throws -> Any {
        let data: Data = try await put(route, body: body)
        return try JSONSerialization.jsonObject(with: data, options: [])
    }
    
    func put(_ route: String, body: HTTPBody? = nil) async throws -> Data {
        try await request(.put, route, body: body).execute()
    }
}
