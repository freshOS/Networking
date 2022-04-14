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

    func delete(_ route: String, params: Params = Params()) -> AnyPublisher<Void, Error> {
        delete(route, params: params)
            .map { (data: Data) -> Void in () }
            .eraseToAnyPublisher()
    }
}

public extension NetworkingClient {

    func get(_ route: String, params: Params = Params()) async throws {
        _ = try await execute(request: request(.get, route, params: params))
    }
    
    func post(_ route: String, params: Params = Params()) async throws {
        _ = try await execute(request: request(.post, route, params: params))
    }
    
    func put(_ route: String, params: Params = Params()) async throws {
        _ = try await execute(request: request(.put, route, params: params))
    }
    
    func patch(_ route: String, params: Params = Params()) async throws {
        let req = request(.patch, route, params: params)
        _ = try await execute(request: req)
    }
    
    func delete(_ route: String, params: Params = Params()) async throws {
        let req = request(.delete, route, params: params)
        _ = try await execute(request: req)
    }
}
