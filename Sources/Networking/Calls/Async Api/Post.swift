//
//  Post.swift
//
//
//  Created by Sacha Durand Saint Omer on 12/11/2023.
//

import Foundation

public extension NetworkingClient {
    
    func post(_ route: String, body: HTTPBody? = nil) async throws {
        let _: Data = try await post(route, body: body)
    }
    
    
    func post<T: Decodable>(_ route: String,
                            body: HTTPBody? = nil,
                            keypath: String? = nil) async throws -> T {
        let json: Any = try await post(route, body: body)
        return try toModel(json, keypath: keypath)
    }
    
    func post<T: Decodable>(_ route: String,
                            body: HTTPBody? = nil,
                            keypath: String? = nil) async throws -> T where T: Collection {
        let keypath = keypath ?? defaultCollectionParsingKeyPath
        let json: Any = try await post(route, body: body)
        return try toModel(json, keypath: keypath)
    }
    
    func post(_ route: String, body: HTTPBody? = nil) async throws -> Any {
        let data: Data = try await post(route, body: body)
        return try JSONSerialization.jsonObject(with: data, options: [])
    }
    
    func post(_ route: String, body: HTTPBody? = nil) async throws -> Data {
        try await request(.post, route, body: body).execute()
    }
}
