//
//  NetworkingClient+Void.swift
//
//
//  Created by Sacha on 13/03/2020.
//

import Foundation
import Combine

public extension NetworkingClient {

    func get(_ route: String, params: Params = Params()) -> AnyPublisher<Void, Error> {
        get(route, params: params)
            .map { (data: Data) -> Void in () }
            .eraseToAnyPublisher()
    }

    func post(_ route: String, params: Params = Params()) -> AnyPublisher<Void, Error> {
        post(route, params: params)
            .map { (data: Data) -> Void in () }
        .eraseToAnyPublisher()
    }
    
    func post<E: Encodable>(_ route: String, encodable: E) -> AnyPublisher<Void, Error> {
        post(route, encodable: encodable)
            .map { (data: Data) -> Void in () }
        .eraseToAnyPublisher()
    }

    func put(_ route: String, params: Params = Params()) -> AnyPublisher<Void, Error> {
        put(route, params: params)
            .map { (data: Data) -> Void in () }
            .eraseToAnyPublisher()
    }
    
    func patch(_ route: String, params: Params = Params()) -> AnyPublisher<Void, Error> {
        patch(route, params: params)
            .map { (data: Data) -> Void in () }
            .eraseToAnyPublisher()
    }
    
    func patch<E: Encodable>(_ route: String, encodable: E) -> AnyPublisher<Void, Error> {
        patch(route, encodable: encodable)
            .map { (data: Data) -> Void in () }
        .eraseToAnyPublisher()
    }

    func delete(_ route: String, params: Params = Params()) -> AnyPublisher<Void, Error> {
        delete(route, params: params)
            .map { (data: Data) -> Void in () }
            .eraseToAnyPublisher()
    }
}

public extension NetworkingClient {

    func get(_ route: String, params: Params = Params()) async throws {
        let req = request(.get, route, params: params)
        _ = try await req.execute()
    }
    
    func post(_ route: String, params: Params = Params()) async throws {
        let req = request(.post, route, params: params)
        _ = try await req.execute()
    }
    
    func post<E: Encodable>(_ route: String, encodable: E) async throws {
        let req = request(.post, route, encodableParams: encodable)
        _ = try await req.execute()
    }
    
    func put(_ route: String, params: Params = Params()) async throws {
        let req = request(.put, route, params: params)
        _ = try await req.execute()
    }
    
    func patch(_ route: String, params: Params = Params()) async throws {
        let req = request(.patch, route, params: params)
        _ = try await req.execute()
    }
    
    func delete(_ route: String, params: Params = Params()) async throws {
        let req = request(.delete, route, params: params)
        _ = try await req.execute()
    }
}
