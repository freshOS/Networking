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
        publisher(request: createRequest(.get, route, params: params))
    }

    func post(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
        publisher(request: createRequest(.post, route, params: params))
    }
    
    func post(_ route: String, body: Encodable) -> AnyPublisher<Data, Error> {
        publisher(request: createRequest(.post, route, encodableBody: body))
    }

    func put(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
        publisher(request: createRequest(.put, route, params: params))
    }

    func patch(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
        publisher(request: createRequest(.patch, route, params: params))
    }
    
    func patch(_ route: String, body: Encodable) -> AnyPublisher<Data, Error> {
        publisher(request: createRequest(.patch, route, encodableBody: body))
    }

    func delete(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
        publisher(request: createRequest(.delete, route, params: params))
    }
}
