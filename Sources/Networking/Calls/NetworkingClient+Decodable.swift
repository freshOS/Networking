//
//  NetworkingClient+Decodable.swift
//  
//
//  Created by Sacha DSO on 12/04/2022.
//

import Foundation
import Combine

public extension NetworkingClient {

    func post<T: Decodable>(_ route: String,
                            body: HTTPBody? = nil,
                                          keypath: String? = nil) -> AnyPublisher<T, Error> {
        return post(route, body: body)
            .tryMap { json -> T in try self.toModel(json, keypath: keypath) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // Array version
    func post<T: Decodable>(_ route: String,
                            body: HTTPBody? = nil,
                           keypath: String? = nil) -> AnyPublisher<T, Error> where T: Collection {
        let keypath = keypath ?? defaultCollectionParsingKeyPath
        return post(route, body: body)
            .tryMap { json -> T in try self.toModel(json, keypath: keypath) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func put<T: Decodable>(_ route: String,
                           body: HTTPBody? = nil,
                                         keypath: String? = nil) -> AnyPublisher<T, Error> {
        return put(route, body: body)
            .tryMap { json -> T in try self.toModel(json, keypath: keypath) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // Array version
    func put<T: Decodable>(_ route: String,
                           body: HTTPBody? = nil,
                           keypath: String? = nil) -> AnyPublisher<T, Error> where T: Collection {
        let keypath = keypath ?? defaultCollectionParsingKeyPath
        return put(route, body: body)
            .tryMap { json -> T in try self.toModel(json, keypath: keypath) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func patch<T: Decodable>(_ route: String,
                             body: HTTPBody? = nil,
                                           keypath: String? = nil) -> AnyPublisher<T, Error> {
        return patch(route, body: body)
            .tryMap { json -> T in try self.toModel(json, keypath: keypath) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    
    // Array version
    func patch<T: Decodable>(_ route: String,
                             body: HTTPBody? = nil,
                           keypath: String? = nil) -> AnyPublisher<T, Error> where T: Collection {
        let keypath = keypath ?? defaultCollectionParsingKeyPath
        return patch(route, body: body)
            .tryMap { json -> T in try self.toModel(json, keypath: keypath) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func delete<T: Decodable>(_ route: String,
                                            keypath: String? = nil) -> AnyPublisher<T, Error> {
        return delete(route)
            .tryMap { json -> T in try self.toModel(json, keypath: keypath) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // Array version
    func delete<T: Decodable>(_ route: String,
                           keypath: String? = nil) -> AnyPublisher<T, Error> where T: Collection {
        let keypath = keypath ?? defaultCollectionParsingKeyPath
        return delete(route)
            .tryMap { json -> T in try self.toModel(json, keypath: keypath) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
