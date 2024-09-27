//
//  NetworkingService.swift
//
//
//  Created by Sacha on 13/03/2020.
//

import Foundation

public protocol NetworkingService {
    var network: NetworkingClient { get }
}

// Sugar, just forward calls to underlying network client

// Async
public extension NetworkingService {
    
    // Data
    
    func get(_ route: String, params: Params = Params()) async throws -> Data {
        try await network.get(route, params: params)
    }
    
    func post(_ route: String, params: Params = Params()) async throws -> Data {
        try await network.post(route, params: params)
    }
    
    func post(_ route: String, body: Encodable & Sendable) async throws -> Data {
        try await network.post(route, body: body)
    }

    func put(_ route: String, params: Params = Params()) async throws -> Data {
        try await network.put(route, params: params)
    }

    func patch(_ route: String, params: Params = Params()) async throws -> Data {
        try await network.patch(route, params: params)
    }

    func delete(_ route: String, params: Params = Params()) async throws -> Data {
        try await network.delete(route, params: params)
    }

    // Void

    func get(_ route: String, params: Params = Params()) async throws {
        return try await network.get(route, params: params)
    }

    func post(_ route: String, params: Params = Params()) async throws {
        return try await network.post(route, params: params)
    }
    
    func post(_ route: String, body: Encodable & Sendable) async throws {
        return try await network.post(route, body: body)
    }

    func put(_ route: String, params: Params = Params()) async throws {
        return try await network.put(route, params: params)
    }

    func patch(_ route: String, params: Params = Params()) async throws {
        return try await network.patch(route, params: params)
    }

    func delete(_ route: String, params: Params = Params()) async throws {
        return try await network.delete(route, params: params)
    }

    // JSON
    
    func get(_ route: String, params: Params = Params()) async throws -> Any {
        try await network.get(route, params: params)
    }

    func get(_ route: String, params: Params = Params()) async throws -> JSON {
        try await network.get(route, params: params)
    }

    func post(_ route: String, params: Params = Params()) async throws -> JSON {
        try await network.post(route, params: params)
    }
    
    func post(_ route: String, body: Encodable & Sendable) async throws -> JSON {
        try await network.post(route, body: body)
    }

    func put(_ route: String, params: Params = Params()) async throws -> JSON {
        try await network.put(route, params: params)
    }
    
    func patch(_ route: String, params: Params = Params()) async throws -> Any {
        try await network.patch(route, params: params)
    }

    func patch(_ route: String, params: Params = Params()) async throws -> JSON {
        try await network.patch(route, params: params)
    }

    func delete(_ route: String, params: Params = Params()) async throws -> JSON {
        try await network.delete(route, params: params)
    }

    // Decodable

    func get<T: Decodable & Sendable>(_ route: String,
                           params: Params = Params(),
                           keypath: String? = nil) async throws -> T {
        try await network.get(route, params: params, keypath: keypath)
    }
    
//    func get<T: Sendable, U:JSONModel<T> & Sendable>(_ route: String,
//                           params: Params = Params(),
//                           keypath: String? = nil,
//                                                      decodeVia: U.Type) async throws -> T {
//        
//        let mod :U = try await network.get(route, params: params, keypath: keypath)
//        return mod.toModel()
//    }
    
//    func get<T: HasJSONModel>(_ route: String,
//                           params: Params = Params(),
//                              keypath: String? = nil) async throws -> T where T.ENCODE: Sendable {
//        let foo: T.ENCODE = try await get(route, params: params, keypath: keypath)
//        return foo.toModel()
//    }


    func post<T: Decodable & Sendable>(_ route: String,
                                          params: Params = Params(),
                                          keypath: String? = nil) async throws -> T {
        try await network.post(route, params: params, keypath: keypath)
    }
    
    func post<T: Decodable & Sendable>(_ route: String, body: Encodable & Sendable) async throws -> T {
        try await network.post(route, body: body)
    }
    
    func put<T: Decodable & Sendable>(_ route: String,
                                         params: Params = Params(),
                                         keypath: String? = nil) async throws -> T {
        try await network.put(route, params: params, keypath: keypath)
    }

    func patch<T: Decodable & Sendable>(_ route: String,
                                           params: Params = Params(),
                                           keypath: String? = nil) async throws -> T {
        try await network.patch(route, params: params, keypath: keypath)
    }
    
    func patch<T: Decodable & Sendable>(_ route: String, body: Encodable & Sendable) async throws -> T {
        try await network.patch(route, body: body)
    }

    func delete<T: Decodable & Sendable>(_ route: String,
                                            params: Params = Params(),
                                            keypath: String? = nil) async throws -> T {
        try await network.delete(route, params: params, keypath: keypath)
    }

    // Array Decodable

    func get<T: Decodable & Sendable>(_ route: String,
                           params: Params = Params(),
                           keypath: String? = nil) async throws -> T where T: Collection {
        try await network.get(route, params: params, keypath: keypath)
    }

    func post<T: Decodable & Sendable>(_ route: String,
                           params: Params = Params(),
                           keypath: String? = nil) async throws -> T where T: Collection {
        try await network.post(route, params: params, keypath: keypath)
    }

    func put<T: Decodable & Sendable>(_ route: String,
                           params: Params = Params(),
                           keypath: String? = nil) async throws -> T where T: Collection {
        try await network.put(route, params: params, keypath: keypath)
    }

    func patch<T: Decodable & Sendable>(_ route: String,
                           params: Params = Params(),
                           keypath: String? = nil) async throws -> T where T: Collection {
        try await network.patch(route, params: params, keypath: keypath)
    }

    func delete<T: Decodable & Sendable>(_ route: String,
                           params: Params = Params(),
                           keypath: String? = nil) async throws -> T where T: Collection {
        try await network.delete(route, params: params, keypath: keypath)
    }
}
