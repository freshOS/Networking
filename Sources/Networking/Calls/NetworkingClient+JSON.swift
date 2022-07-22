//
//  NetworkingClient+JSON.swift
//
//
//  Created by Sacha on 13/03/2020.
//

import Foundation
import Combine

public extension NetworkingClient {

    func get(_ route: String, params: Params = Params()) -> AnyPublisher<Any, Error> {
        get(route, params: params).toJSON()
    }

    func post(_ route: String, params: Params = Params()) -> AnyPublisher<Any, Error> {
        post(route, params: params).toJSON()
    }
    
    func post<E: Encodable>(_ route: String, encodable: E) -> AnyPublisher<Any, Error> {
        post(route, encodable: encodable).toJSON()
    }

    func put(_ route: String, params: Params = Params()) -> AnyPublisher<Any, Error> {
        put(route, params: params).toJSON()
    }

    func patch(_ route: String, params: Params = Params()) -> AnyPublisher<Any, Error> {
        patch(route, params: params).toJSON()
    }

    func delete(_ route: String, params: Params = Params()) -> AnyPublisher<Any, Error> {
        delete(route, params: params).toJSON()
    }
}

public extension NetworkingClient {

    func get(_ route: String, params: Params = Params()) async throws -> Any {
        let req = request(.get, route, params: params)
        let data = try await req.execute()
        return try JSONSerialization.jsonObject(with: data, options: [])
    }
    
    func post(_ route: String, params: Params = Params()) async throws -> Any {
        let req = request(.post, route, params: params)
        let data = try await req.execute()
        return try JSONSerialization.jsonObject(with: data, options: [])
    }
    
    func post<E: Encodable>(_ route: String, encodable: E) async throws -> Any {
        let req = request(.post, route, encodableParams: encodable)
        let data = try await req.execute()
        return try JSONSerialization.jsonObject(with: data, options: [])
    }
    
    func put(_ route: String, params: Params = Params()) async throws -> Any {
        let req = request(.put, route, params: params)
        let data = try await req.execute()
        return try JSONSerialization.jsonObject(with: data, options: [])
    }
    
    func patch(_ route: String, params: Params = Params()) async throws -> Any {
        let req = request(.patch, route, params: params)
        let data = try await req.execute()
        return try JSONSerialization.jsonObject(with: data, options: [])
    }
    
    func patch<E: Encodable>(_ route: String, encodable: E) async throws -> Any {
        let req = request(.patch, route, encodableParams: encodable)
        let data = try await req.execute()
        return try JSONSerialization.jsonObject(with: data, options: [])
    }
    
    func delete(_ route: String, params: Params = Params()) async throws -> Any {
        let req = request(.delete, route, params: params)
        let data = try await req.execute()
        return try JSONSerialization.jsonObject(with: data, options: [])
    }
}

// Data to JSON
extension Publisher where Output == Data {

    public func toJSON() -> AnyPublisher<Any, Error> {
         tryMap { data -> Any in
            return try JSONSerialization.jsonObject(with: data, options: [])
        }.eraseToAnyPublisher()
    }
}
