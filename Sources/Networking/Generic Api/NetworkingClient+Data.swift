//
//  NetworkingClient+Data.swift
//
//
//  Created by Sacha on 13/03/2020.
//

import Foundation
import Combine

public extension NetworkingClient {

    func get(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
        publisher(for: request(.get, route, params: params))
    }

    func post(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
        publisher(for: request(.post, route, params: params))
    }

    func put(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
        publisher(for: request(.put, route, params: params))
    }

    func patch(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
        publisher(for: request(.patch, route, params: params))
    }

    func delete(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
        publisher(for: request(.delete, route, params: params))
    }
}

public extension NetworkingClient {

    func get(_ route: String, params: Params = Params()) async throws -> Data {
        try await execute(request: request(.get, route, params: params))
    }
    
    func post(_ route: String, params: Params = Params()) async throws -> Data {
        try await execute(request: request(.post, route, params: params))
    }
    
    func put(_ route: String, params: Params = Params()) async throws -> Data {
        try await execute(request: request(.put, route, params: params))
    }
    
    func patch(_ route: String, params: Params = Params()) async throws -> Data {
        try await execute(request: request(.patch, route, params: params))
    }
    
    func delete(_ route: String, params: Params = Params()) async throws -> Data {
        try await execute(request: request(.delete, route, params: params))
    }
}
