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

// Data to JSON
extension Publisher where Output == Data {

    public func toJSON() -> AnyPublisher<Any, Error> {
         tryMap { data -> Any in
            return try JSONSerialization.jsonObject(with: data, options: [])
        }.eraseToAnyPublisher()
    }
}
