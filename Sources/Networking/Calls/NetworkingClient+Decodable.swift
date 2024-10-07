//
//  NetworkingClient+Decodable.swift
//  
//
//  Created by Sacha DSO on 12/04/2022.
//

import Foundation

public extension NetworkingClient {
    
    func get<T: Decodable>(_ route: String,
                           params: Params = Params(),
                           keypath: String? = nil) async throws -> T {
        let json: JSON = try await get(route, params: params)
        let model:T = try self.toModel(json, keypath: keypath)
        return model
    }
    
    func get<T: Decodable>(_ route: String,
                           params: Params = Params(),
                           keypath: String? = nil) async throws -> T where T: Collection {
        let keypath = keypath ?? defaultCollectionParsingKeyPath
        let json: JSON = try await get(route, params: params)
        return try self.toModel(json, keypath: keypath)
    }
    
    func post<T: Decodable>(_ route: String,
                           params: Params = Params(),
                           keypath: String? = nil) async throws -> T {
        let json: JSON = try await post(route, params: params)
        return try self.toModel(json, keypath: keypath)
    }
    
    func post<T: Decodable>(_ route: String,
                                          body: Encodable & Sendable,
                                          keypath: String? = nil
    ) async throws -> T {
        let json: JSON = try await post(route, body: body)
        return try self.toModel(json, keypath: keypath)
    }
    
    func post<T: Decodable>(_ route: String,
                           params: Params = Params(),
                           keypath: String? = nil) async throws -> T where T: Collection {
        let keypath = keypath ?? defaultCollectionParsingKeyPath
        let json: JSON = try await post(route, params: params)
        return try self.toModel(json, keypath: keypath)
    }
    
    func put<T: Decodable>(_ route: String,
                           params: Params = Params(),
                           keypath: String? = nil) async throws -> T {
        let json: JSON = try await put(route, params: params)
        return try self.toModel(json, keypath: keypath)
    }
    
    func put<T: Decodable>(_ route: String,
                           params: Params = Params(),
                           keypath: String? = nil) async throws -> T where T: Collection {
        let keypath = keypath ?? defaultCollectionParsingKeyPath
        let json: JSON = try await put(route, params: params)
        return try self.toModel(json, keypath: keypath)
    }
    
    func patch<T: Decodable>(_ route: String,
                           params: Params = Params(),
                           keypath: String? = nil) async throws -> T {
        let json: JSON = try await patch(route, params: params)
        return try self.toModel(json, keypath: keypath)
    }
    
    func patch<T: Decodable>(_ route: String,
                           params: Params = Params(),
                           keypath: String? = nil) async throws -> T where T: Collection {
        let keypath = keypath ?? defaultCollectionParsingKeyPath
        let json: JSON = try await patch(route, params: params)
        return try self.toModel(json, keypath: keypath)
    }
    
    func patch<T: Decodable>(_ route: String,
                                          body: Encodable & Sendable,
                                          keypath: String? = nil
    ) async throws -> T {
        let json: JSON = try await patch(route, body: body)
        return try self.toModel(json, keypath: keypath)
    }
    
    func delete<T: Decodable>(_ route: String,
                           params: Params = Params(),
                           keypath: String? = nil) async throws -> T {
        let json: JSON = try await delete(route, params: params)
        return try self.toModel(json, keypath: keypath)
    }
    
    func delete<T: Decodable>(_ route: String,
                           params: Params = Params(),
                           keypath: String? = nil) async throws -> T where T: Collection {
        let keypath = keypath ?? defaultCollectionParsingKeyPath
        let json: JSON = try await delete(route, params: params)
        return try self.toModel(json, keypath: keypath)
    }
}
