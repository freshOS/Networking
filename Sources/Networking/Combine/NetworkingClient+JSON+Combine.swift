//
//  NetworkingClient+JSON.swift
//
//
//  Created by Sacha on 13/03/2020.
//

import Foundation
import Combine

public extension NetworkingClient {
    
    func get(_ route: String, params: Params = Params()) -> AnyPublisher<Sendable, Error> {
        get(route, params: params).toJSONSendable()
    }

    func get(_ route: String, params: Params = Params()) -> AnyPublisher<JSON, Error> {
        get(route, params: params).toJSON()
    }

    func post(_ route: String, params: Params = Params()) -> AnyPublisher<JSON, Error> {
        post(route, params: params).toJSON()
    }
    
    func post(_ route: String, body: Encodable) -> AnyPublisher<JSON, Error> {
        post(route, body: body).toJSON()
    }

    func put(_ route: String, params: Params = Params()) -> AnyPublisher<JSON, Error> {
        put(route, params: params).toJSON()
    }

    func patch(_ route: String, params: Params = Params()) -> AnyPublisher<JSON, Error> {
        patch(route, params: params).toJSON()
    }
    
    func patch(_ route: String, body: Encodable) -> AnyPublisher<JSON, Error> {
        patch(route, body: body).toJSON()
    }
    
    func delete(_ route: String, params: Params = Params()) -> AnyPublisher<Sendable, Error> {
        delete(route, params: params).toJSONSendable()
    }

    func delete(_ route: String, params: Params = Params()) -> AnyPublisher<JSON, Error> {
        delete(route, params: params).toJSON()
    }
}



// Data to JSON
extension Publisher where Output == Data {

    public func toJSON() -> AnyPublisher<JSON, Error> {
         tryMap { data -> JSON in
             let json = try JSONSerialization.jsonObject(with: data, options: [])
             return JSON(jsonObject: json)
        }.eraseToAnyPublisher()
    }
    
    public func toJSONSendable() -> AnyPublisher<Sendable, Error> {
         tryMap { data -> Any in
             let json = try JSONSerialization.jsonObject(with: data, options: [])
             return json
        }.eraseToAnyPublisher()
    }
}

