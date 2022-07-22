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
        request(.get, route, params: params).publisher()
    }

    func post(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
        request(.post, route, params: params).publisher()
    }
    
    func post<E: Encodable>(_ route: String, encodable: E) -> AnyPublisher<Data, Error> {
        request(.post, route, encodableParams: encodable).publisher()
    }

    func put(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
        request(.put, route, params: params).publisher()
    }

    func patch(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
        request(.patch, route, params: params).publisher()
    }
    
    func patch<E: Encodable>(_ route: String, encodable: E) -> AnyPublisher<Data, Error> {
        request(.patch, route, encodableParams: encodable).publisher()
    }

    func delete(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
        request(.delete, route, params: params).publisher()
    }
}

public extension NetworkingClient {

    func get(_ route: String, params: Params = Params()) async throws -> Data {
        try await request(.get, route, params: params).execute()
    }
    
    func post(_ route: String, params: Params = Params()) async throws -> Data {
        try await request(.post, route, params: params).execute()
    }
    
    func post<E: Encodable>(_ route: String, encodable: E) async throws -> Data {
        try await request(.post, route, encodableParams: encodable).execute()
    }
    
    func put(_ route: String, params: Params = Params()) async throws -> Data {
        try await request(.put, route, params: params).execute()
    }
    
    func patch(_ route: String, params: Params = Params()) async throws -> Data {
        try await request(.patch, route, params: params).execute()
    }
    
    func delete(_ route: String, params: Params = Params()) async throws -> Data {
        try await request(.delete, route, params: params).execute()
    }
}
