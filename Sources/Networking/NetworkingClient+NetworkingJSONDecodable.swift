//
//  NetworkingClient+NetworkingJSONDecodable.swift
//
//
//  Created by Sacha on 13/03/2020.
//

import Foundation
import Combine


public protocol NetworkingJSONDecodable {
    /// The method you declare your JSON mapping in.
    static func decode(_ json: Any) throws -> Self
}

public extension NetworkingClient {

    func get<T: NetworkingJSONDecodable>(_ route: String,
                                         urlParams: Params? = nil,
                                         keypath: String? = nil) -> AnyPublisher<T, Error> {
        return get(route, urlParams: urlParams)
            .tryMap { json -> T in try self.toModel(json, keypath: keypath) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    // Array version
    func get<T: NetworkingJSONDecodable>(_ route: String,
                                         urlParams: Params? = nil,
                                         keypath: String? = nil) -> AnyPublisher<[T], Error> {
        let keypath = keypath ?? defaultCollectionParsingKeyPath
        return get(route, urlParams: urlParams)
            .tryMap { json -> [T] in try self.toModels(json, keypath: keypath) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func post<T: NetworkingJSONDecodable>(_ route: String,
                                          body: HTTPBody? = nil,
                                          keypath: String? = nil) -> AnyPublisher<T, Error> {
        return post(route, body: body)
            .tryMap { json -> T in try self.toModel(json, keypath: keypath) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // Array version
    func post<T: NetworkingJSONDecodable>(_ route: String,
                                          body: HTTPBody? = nil,
                                         keypath: String? = nil) -> AnyPublisher<[T], Error> {
        let keypath = keypath ?? defaultCollectionParsingKeyPath
        return post(route, body: body)
            .tryMap { json -> [T] in try self.toModels(json, keypath: keypath) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func put<T: NetworkingJSONDecodable>(_ route: String,
                                         body: HTTPBody? = nil,
                                         keypath: String? = nil) -> AnyPublisher<T, Error> {
        return put(route, body: body)
            .tryMap { json -> T in try self.toModel(json, keypath: keypath) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    
    // Array version
    func put<T: NetworkingJSONDecodable>(_ route: String,
                                         body: HTTPBody? = nil,
                                         keypath: String? = nil) -> AnyPublisher<[T], Error> {
        let keypath = keypath ?? defaultCollectionParsingKeyPath
        return put(route, body: body)
            .tryMap { json -> [T] in try self.toModels(json, keypath: keypath) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func patch<T: NetworkingJSONDecodable>(_ route: String,
                                           body: HTTPBody? = nil,
                                           keypath: String? = nil) -> AnyPublisher<T, Error> {
        return patch(route, body: body)
            .tryMap { json -> T in try self.toModel(json, keypath: keypath) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // Array version
    func patch<T: NetworkingJSONDecodable>(_ route: String,
                                           body: HTTPBody? = nil,
                                         keypath: String? = nil) -> AnyPublisher<[T], Error> {
        let keypath = keypath ?? defaultCollectionParsingKeyPath
        return patch(route, body: body)
            .tryMap { json -> [T] in try self.toModels(json, keypath: keypath) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func delete<T: NetworkingJSONDecodable>(_ route: String,
                                            keypath: String? = nil) -> AnyPublisher<T, Error> {
        return delete(route)
            .tryMap { json -> T in try self.toModel(json, keypath: keypath) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // Array version
    func delete<T: NetworkingJSONDecodable>(_ route: String,
                                         keypath: String? = nil) -> AnyPublisher<[T], Error> {
        let keypath = keypath ?? defaultCollectionParsingKeyPath
        return delete(route)
            .tryMap { json -> [T] in try self.toModels(json, keypath: keypath) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
