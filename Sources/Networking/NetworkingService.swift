//
//  NetworkingService.swift
//
//
//  Created by Sacha on 13/03/2020.
//

import Foundation
import Combine

public protocol NetworkingService {
    var network: NetworkingClient { get }
}

// Sugar, just forward calls to underlying network client

public extension NetworkingService {
    
    // Data
    
    func get(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
        network.get(route, params: params)
    }
    
    func post(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
        network.post(route, params: params)
    }
    
    func post<E: Encodable>(_ route: String, encodable: E) -> AnyPublisher<Data, Error> {
        network.post(route, encodable: encodable)
    }
    
    func put(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
        network.put(route, params: params)
    }
    
    func patch(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
        network.patch(route, params: params)
    }
    
    func delete(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
        network.delete(route, params: params)
    }
    
    // Void
    
    func get(_ route: String, params: Params = Params()) -> AnyPublisher<Void, Error> {
        network.get(route, params: params)
    }
    
    func post(_ route: String, params: Params = Params()) -> AnyPublisher<Void, Error> {
        network.post(route, params: params)
    }
    
    func post<E: Encodable>(_ route: String, encodable: E) -> AnyPublisher<Void, Error> {
        network.post(route, encodable: encodable)
    }
    
    func put(_ route: String, params: Params = Params()) -> AnyPublisher<Void, Error> {
        network.put(route, params: params)
    }
    
    func patch(_ route: String, params: Params = Params()) -> AnyPublisher<Void, Error> {
        network.patch(route, params: params)
    }
    
    func delete(_ route: String, params: Params = Params()) -> AnyPublisher<Void, Error> {
        network.delete(route, params: params)
    }
    
    // JSON
    
    func get(_ route: String, params: Params = Params()) -> AnyPublisher<Any, Error> {
        network.get(route, params: params)
    }
    
    func post(_ route: String, params: Params = Params()) -> AnyPublisher<Any, Error> {
        network.post(route, params: params)
    }
    
    func post<E: Encodable>(_ route: String, encodable: E) -> AnyPublisher<Any, Error> {
        network.post(route, encodable: encodable)
    }
    
    func put(_ route: String, params: Params = Params()) -> AnyPublisher<Any, Error> {
        network.put(route, params: params)
    }
    
    func patch(_ route: String, params: Params = Params()) -> AnyPublisher<Any, Error> {
        network.patch(route, params: params)
    }
    
    func delete(_ route: String, params: Params = Params()) -> AnyPublisher<Any, Error> {
        network.delete(route, params: params)
    }
    
    // Decodable
    
    func get<T: Decodable>(_ route: String,
                                         params: Params = Params(),
                                         keypath: String? = nil) -> AnyPublisher<T, Error> {
        network.get(route, params: params, keypath: keypath)
    }
    
    func post<T: Decodable>(_ route: String,
                                          params: Params = Params(),
                                          keypath: String? = nil) -> AnyPublisher<T, Error> {
        network.post(route, params: params, keypath: keypath)
    }
    
    func put<T: Decodable>(_ route: String,
                                         params: Params = Params(),
                                         keypath: String? = nil) -> AnyPublisher<T, Error> {
        network.put(route, params: params, keypath: keypath)
    }
    
    func patch<T: Decodable>(_ route: String,
                                           params: Params = Params(),
                                           keypath: String? = nil) -> AnyPublisher<T, Error> {
        network.patch(route, params: params, keypath: keypath)
    }
    
    func delete<T: Decodable>(_ route: String,
                                            params: Params = Params(),
                                            keypath: String? = nil) -> AnyPublisher<T, Error> {
        network.delete(route, params: params, keypath: keypath)
    }
    
    // Array Decodable
    
    func get<T: Decodable>(_ route: String,
                           params: Params = Params(),
                           keypath: String? = nil) -> AnyPublisher<T, Error> where T: Collection {
        network.get(route, params: params, keypath: keypath)
    }
    
    func post<T: Decodable>(_ route: String,
                           params: Params = Params(),
                           keypath: String? = nil) -> AnyPublisher<T, Error> where T: Collection {
        network.post(route, params: params, keypath: keypath)
    }
    
    func put<T: Decodable>(_ route: String,
                           params: Params = Params(),
                           keypath: String? = nil) -> AnyPublisher<T, Error> where T: Collection {
        network.put(route, params: params, keypath: keypath)
    }
    
    func patch<T: Decodable>(_ route: String,
                           params: Params = Params(),
                           keypath: String? = nil) -> AnyPublisher<T, Error> where T: Collection {
        network.patch(route, params: params, keypath: keypath)
    }
    
    func delete<T: Decodable>(_ route: String,
                           params: Params = Params(),
                           keypath: String? = nil) -> AnyPublisher<T, Error> where T: Collection {
        network.delete(route, params: params, keypath: keypath)
    }
    
    // NetworkingJSONDecodable
    
    func get<T: NetworkingJSONDecodable>(_ route: String,
                                         params: Params = Params(),
                                         keypath: String? = nil) -> AnyPublisher<T, Error> {
        network.get(route, params: params, keypath: keypath)
    }
    
    func post<T: NetworkingJSONDecodable>(_ route: String,
                                          params: Params = Params(),
                                          keypath: String? = nil) -> AnyPublisher<T, Error> {
        network.post(route, params: params, keypath: keypath)
    }
    
    func put<T: NetworkingJSONDecodable>(_ route: String,
                                         params: Params = Params(),
                                         keypath: String? = nil) -> AnyPublisher<T, Error> {
        network.put(route, params: params, keypath: keypath)
    }
    
    func patch<T: NetworkingJSONDecodable>(_ route: String,
                                           params: Params = Params(),
                                           keypath: String? = nil) -> AnyPublisher<T, Error> {
        network.patch(route, params: params, keypath: keypath)
    }
    
    func delete<T: NetworkingJSONDecodable>(_ route: String,
                                            params: Params = Params(),
                                            keypath: String? = nil) -> AnyPublisher<T, Error> {
        network.delete(route, params: params, keypath: keypath)
    }
    
    
    
    // Array NetworkingJSONDecodable
    
    func get<T: NetworkingJSONDecodable>(_ route: String,
                                         params: Params = Params(),
                                         keypath: String? = nil) -> AnyPublisher<[T], Error> {
        network.get(route, params: params, keypath: keypath)
    }
    
    func post<T: NetworkingJSONDecodable>(_ route: String,
                                          params: Params = Params(),
                                          keypath: String? = nil) -> AnyPublisher<[T], Error> {
        network.post(route, params: params, keypath: keypath)
    }
    
    func put<T: NetworkingJSONDecodable>(_ route: String,
                                         params: Params = Params(),
                                         keypath: String? = nil) -> AnyPublisher<[T], Error> {
        network.put(route, params: params, keypath: keypath)
    }
    
    func patch<T: NetworkingJSONDecodable>(_ route: String,
                                           params: Params = Params(),
                                           keypath: String? = nil) -> AnyPublisher<[T], Error> {
        network.patch(route, params: params, keypath: keypath)
    }
    
    func delete<T: NetworkingJSONDecodable>(_ route: String,
                                            params: Params = Params(),
                                            keypath: String? = nil) -> AnyPublisher<[T], Error> {
        network.delete(route, params: params, keypath: keypath)
    }
}

// Async
public extension NetworkingService {
    
    // Data
    
    func get(_ route: String, params: Params = Params()) async throws -> Data {
        try await network.get(route, params: params)
    }
    
    func post(_ route: String, params: Params = Params()) async throws -> Data {
        try await network.post(route, params: params)
    }
    
    func post<E: Encodable>(_ route: String, encodable: E) async throws -> Data {
        try await network.post(route, encodable: encodable)
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
    
    func post<E: Encodable>(_ route: String, encodable: E) async throws {
        return try await network.post(route, encodable: encodable)
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

    func post(_ route: String, params: Params = Params()) async throws -> Any {
        try await network.post(route, params: params)
    }
    
    func post<E: Encodable>(_ route: String, encodable: E) async throws -> Any {
        try await network.post(route, encodable: encodable)
    }

    func put(_ route: String, params: Params = Params()) async throws -> Any {
        try await network.put(route, params: params)
    }

    func patch(_ route: String, params: Params = Params()) async throws -> Any {
        try await network.patch(route, params: params)
    }

    func delete(_ route: String, params: Params = Params()) async throws -> Any {
        try await network.delete(route, params: params)
    }

    // Decodable

    func get<T: Decodable>(_ route: String,
                           params: Params = Params(),
                           keypath: String? = nil) async throws -> T {
        try await network.get(route, params: params, keypath: keypath)
    }

    func post<T: Decodable>(_ route: String,
                                          params: Params = Params(),
                                          keypath: String? = nil) async throws -> T {
        try await network.post(route, params: params, keypath: keypath)
    }
    
    func post<E: Encodable, T: Decodable>(_ route: String, encodable: E) async throws -> T {
        try await network.post(route, encodable: encodable)
    }
    
    func put<T: Decodable>(_ route: String,
                                         params: Params = Params(),
                                         keypath: String? = nil) async throws -> T {
        try await network.put(route, params: params, keypath: keypath)
    }

    func patch<T: Decodable>(_ route: String,
                                           params: Params = Params(),
                                           keypath: String? = nil) async throws -> T {
        try await network.patch(route, params: params, keypath: keypath)
    }

    func delete<T: Decodable>(_ route: String,
                                            params: Params = Params(),
                                            keypath: String? = nil) async throws -> T {
        try await network.delete(route, params: params, keypath: keypath)
    }

    // Array Decodable

    func get<T: Decodable>(_ route: String,
                           params: Params = Params(),
                           keypath: String? = nil) async throws -> T where T: Collection {
        try await network.get(route, params: params, keypath: keypath)
    }

    func post<T: Decodable>(_ route: String,
                           params: Params = Params(),
                           keypath: String? = nil) async throws -> T where T: Collection {
        try await network.post(route, params: params, keypath: keypath)
    }

    func put<T: Decodable>(_ route: String,
                           params: Params = Params(),
                           keypath: String? = nil) async throws -> T where T: Collection {
        try await network.put(route, params: params, keypath: keypath)
    }

    func patch<T: Decodable>(_ route: String,
                           params: Params = Params(),
                           keypath: String? = nil) async throws -> T where T: Collection {
        try await network.patch(route, params: params, keypath: keypath)
    }

    func delete<T: Decodable>(_ route: String,
                           params: Params = Params(),
                           keypath: String? = nil) async throws -> T where T: Collection {
        try await network.delete(route, params: params, keypath: keypath)
    }
}

