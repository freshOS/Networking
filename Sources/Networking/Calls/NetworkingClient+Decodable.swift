//
//  NetworkingClient+Decodable.swift
//  
//
//  Created by Sacha DSO on 12/04/2022.
//

import Foundation
import Combine

public extension NetworkingClient {

    func get<T: Decodable>(_ route: String,
                                         params: Params = Params(),
                                         keypath: String? = nil) -> AnyPublisher<T, Error> {
        return get(route, params: params)
            .tryMap { json -> T in try NetworkingParser().toModel(json, keypath: keypath) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // Array version
    func get<T: Decodable>(_ route: String,
                           params: Params = Params(),
                           keypath: String? = nil) -> AnyPublisher<T, Error> where T: Collection {
        let keypath = keypath ?? defaultCollectionParsingKeyPath
        return get(route, params: params)
            .tryMap { json -> T in try NetworkingParser().toModel(json, keypath: keypath) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func post<T: Decodable>(_ route: String,
                                          params: Params = Params(),
                                          keypath: String? = nil) -> AnyPublisher<T, Error> {
        return post(route, params: params)
            .tryMap { json -> T in try NetworkingParser().toModel(json, keypath: keypath) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // Array version
    func post<T: Decodable>(_ route: String,
                           params: Params = Params(),
                           keypath: String? = nil) -> AnyPublisher<T, Error> where T: Collection {
        let keypath = keypath ?? defaultCollectionParsingKeyPath
        return post(route, params: params)
            .tryMap { json -> T in try NetworkingParser().toModel(json, keypath: keypath) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func put<T: Decodable>(_ route: String,
                                         params: Params = Params(),
                                         keypath: String? = nil) -> AnyPublisher<T, Error> {
        return put(route, params: params)
            .tryMap { json -> T in try NetworkingParser().toModel(json, keypath: keypath) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // Array version
    func put<T: Decodable>(_ route: String,
                           params: Params = Params(),
                           keypath: String? = nil) -> AnyPublisher<T, Error> where T: Collection {
        let keypath = keypath ?? defaultCollectionParsingKeyPath
        return put(route, params: params)
            .tryMap { json -> T in try NetworkingParser().toModel(json, keypath: keypath) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func patch<T: Decodable>(_ route: String,
                                           params: Params = Params(),
                                           keypath: String? = nil) -> AnyPublisher<T, Error> {
        return patch(route, params: params)
            .tryMap { json -> T in try NetworkingParser().toModel(json, keypath: keypath) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // Array version
    func patch<T: Decodable>(_ route: String,
                           params: Params = Params(),
                           keypath: String? = nil) -> AnyPublisher<T, Error> where T: Collection {
        let keypath = keypath ?? defaultCollectionParsingKeyPath
        return patch(route, params: params)
            .tryMap { json -> T in try NetworkingParser().toModel(json, keypath: keypath) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func delete<T: Decodable>(_ route: String,
                                            params: Params = Params(),
                                            keypath: String? = nil) -> AnyPublisher<T, Error> {
        return delete(route, params: params)
            .tryMap { json -> T in try NetworkingParser().toModel(json, keypath: keypath) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // Array version
    func delete<T: Decodable>(_ route: String,
                           params: Params = Params(),
                           keypath: String? = nil) -> AnyPublisher<T, Error> where T: Collection {
        let keypath = keypath ?? defaultCollectionParsingKeyPath
        return delete(route, params: params)
            .tryMap { json -> T in try NetworkingParser().toModel(json, keypath: keypath) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
