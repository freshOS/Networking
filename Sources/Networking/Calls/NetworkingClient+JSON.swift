//
//  NetworkingClient+JSON.swift
//
//
//  Created by Sacha on 13/03/2020.
//

import Foundation
import Combine

public extension NetworkingClient {

    func post(_ route: String, body: HTTPBody? = nil) -> AnyPublisher<Any, Error> {
        post(route, body: body).toJSON()
    }
    
    func put(_ route: String,  body: HTTPBody? = nil) -> AnyPublisher<Any, Error> {
        put(route, body: body).toJSON()
    }

    func patch(_ route: String, body: HTTPBody? = nil) -> AnyPublisher<Any, Error> {
        patch(route, body: body).toJSON()
    }

    func delete(_ route: String) -> AnyPublisher<Any, Error> {
        delete(route).toJSON()
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
