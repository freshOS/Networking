//
//  Patch.swift
//
//
//  Created by Sacha Durand Saint Omer on 12/11/2023.
//

import Foundation

public extension NetworkingClient {
    
    func patch(_ route: String, body: HTTPBody? = nil) async throws {
        let req = request(.patch, route, body: body)
        _ = try await req.execute()
    }
    
    func patch<T: Decodable>(_ route: String,
                             body: HTTPBody? = nil,
                             keypath: String? = nil) async throws -> T {
        let json: Any = try await patch(route, body: body)
        return try self.toModel(json, keypath: keypath)
    }
    
    func patch<T: Decodable>(_ route: String,
                             body: HTTPBody? = nil,
                             keypath: String? = nil) async throws -> T where T: Collection {
        let keypath = keypath ?? defaultCollectionParsingKeyPath
        let json: Any = try await patch(route, body: body)
        return try self.toModel(json, keypath: keypath)
    }
    
    func patch(_ route: String, body: HTTPBody? = nil) async throws -> Any {
        let req = request(.patch, route, body: body)
        let data = try await req.execute()
        return try JSONSerialization.jsonObject(with: data, options: [])
    }
    
    func patch(_ route: String, body: HTTPBody? = nil) async throws -> Data {
        try await request(.patch, route, body: body).execute()
    }
    
}
