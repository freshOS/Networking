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
        request(.get, route: route, params: params)
    }

    func post(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
        request(.post, route: route, params: params)
    }
    
    func post(_ route: String, body: Encodable & Sendable) -> AnyPublisher<Data, Error> {
        publisher(request: createRequest(.post, route, body: body))
    }

    func put(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
        request(.put, route: route, params: params)
    }

    func patch(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
        request(.patch, route: route, params: params)
    }
    
    func patch(_ route: String, body: Encodable & Sendable) -> AnyPublisher<Data, Error> {
        publisher(request: createRequest(.patch, route, body: body))
    }

    func delete(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
        request(.delete, route: route, params: params)
    }
    
    func request(_ httpMethod: HTTPMethod, route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
        publisher(request: createRequest(httpMethod, route, params: params))
    }
}
