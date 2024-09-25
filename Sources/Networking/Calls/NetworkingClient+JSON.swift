//
//  NetworkingClient+JSON.swift
//
//
//  Created by Sacha on 13/03/2020.
//

import Foundation
import Combine

public extension NetworkingClient {

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

    func delete(_ route: String, params: Params = Params()) -> AnyPublisher<JSON, Error> {
        delete(route, params: params).toJSON()
    }
}

public extension NetworkingClient {

    func get(_ route: String, params: Params = Params()) async throws -> JSON {
        let req = request(.get, route, params: params)
        let data = try await execute(request: req)
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        return JSON(jsonObject: json)
    }
    
    func post(_ route: String, params: Params = Params()) async throws -> JSON {
        let req = request(.post, route, params: params)
        let data = try await execute(request: req)
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        return JSON(jsonObject: json)
    }
    
    func post(_ route: String, body: Encodable) async throws -> JSON {
        let req = request(.post, route, encodableBody: body)
        let data = try await execute(request: req)
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        return JSON(jsonObject: json)
    }
    
    func put(_ route: String, params: Params = Params()) async throws -> JSON {
        let req = request(.put, route, params: params)
        let data = try await execute(request: req)
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        return JSON(jsonObject: json)
    }
    
    func patch(_ route: String, params: Params = Params()) async throws -> JSON {
        let req = request(.patch, route, params: params)
        let data = try await execute(request: req)
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        return JSON(jsonObject: json)
    }
    
    func patch(_ route: String, body: Encodable) async throws -> JSON {
        let req = request(.patch, route, encodableBody: body)
        let data = try await execute(request: req)
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        return JSON(jsonObject: json)
    }
    
    func delete(_ route: String, params: Params = Params()) async throws -> JSON {
        let req = request(.delete, route, params: params)
        let data = try await execute(request: req)
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        return JSON(jsonObject: json)
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
}


public struct JSON: Sendable, CustomStringConvertible {
    
    let array: [any Sendable]?
    let dictionary: [String: any Sendable]?
    
    init(jsonObject: Any) {
        if let arr = jsonObject as? [Sendable] {
            array = arr
            dictionary = nil
        } else if let dic = jsonObject as? [String: any Sendable] {
            dictionary = dic
            array = nil
        } else {
            array = nil
            dictionary = nil
        }
    }
    
    var value: Any {
        return array ?? dictionary ?? ""
    }
    
    public var description: String {
        if let array = array {
            return String(describing: array)
        } else if let dictionary = dictionary {
            return String(describing: dictionary)
        }
        return "empty"
    }

}
