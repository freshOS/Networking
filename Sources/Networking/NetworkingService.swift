//
//  NetworkingService.swift
//  
//
//  Created by Sacha on 13/03/2020.
//

import Foundation
import Combine

public protocol NetworkingService {
    var network: NetworkingClient { get }
}

// Sugar, just forward calls to underlying network client

public extension NetworkingService {
    
    // Data
    
    func get(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
        network.get(route, params: params)
    }
    
    func post(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
        network.post(route, params: params)
    }
    
    func put(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
        network.put(route, params: params)
    }
    
    func patch(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
        network.patch(route, params: params)
    }
    
    func delete(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
        network.delete(route, params: params)
    }
    
    // Void
    
    func get(_ route: String, params: Params = Params()) -> AnyPublisher<Void, Error> {
        network.get(route, params: params)
    }
    
    func post(_ route: String, params: Params = Params()) -> AnyPublisher<Void, Error> {
        network.post(route, params: params)
    }
    
    func put(_ route: String, params: Params = Params()) -> AnyPublisher<Void, Error> {
        network.put(route, params: params)
    }
    
    func patch(_ route: String, params: Params = Params()) -> AnyPublisher<Void, Error> {
        network.patch(route, params: params)
    }
    
    func delete(_ route: String, params: Params = Params()) -> AnyPublisher<Void, Error> {
        network.delete(route, params: params)
    }
    
    // JSON
    
    func get(_ route: String, params: Params = Params()) -> AnyPublisher<Any, Error> {
        network.get(route, params: params)
    }
    
    func post(_ route: String, params: Params = Params()) -> AnyPublisher<Any, Error> {
        network.post(route, params: params)
    }
    
    func put(_ route: String, params: Params = Params()) -> AnyPublisher<Any, Error> {
        network.put(route, params: params)
    }
    
    func patch(_ route: String, params: Params = Params()) -> AnyPublisher<Any, Error> {
        network.patch(route, params: params)
    }
    
    func delete(_ route: String, params: Params = Params()) -> AnyPublisher<Any, Error> {
        network.delete(route, params: params)
    }
    
    // NetworkingJSONDecodable
    
    func get<T: NetworkingJSONDecodable>(_ route: String,
                                         params: Params = Params(),
                                         keypath: String? = nil) -> AnyPublisher<T, Error> {
        return get(route, params: params)
            .tryMap { json -> T in try NetworkingParser().toModel(json, keypath: keypath) }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    func post<T: NetworkingJSONDecodable>(_ route: String,
                                          params: Params = Params(),
                                          keypath: String? = nil) -> AnyPublisher<T, Error> {
        network.post(route, params: params, keypath: keypath)
    }
    
    func put<T: NetworkingJSONDecodable>(_ route: String,
                                         params: Params = Params(),
                                         keypath: String? = nil) -> AnyPublisher<T, Error> {
        network.put(route, params: params, keypath: keypath)
    }
    
    func patch<T: NetworkingJSONDecodable>(_ route: String,
                                           params: Params = Params(),
                                           keypath: String? = nil) -> AnyPublisher<T, Error> {
        network.patch(route, params: params, keypath: keypath)
    }
    
    func delete<T: NetworkingJSONDecodable>(_ route: String,
                                            params: Params = Params(),
                                            keypath: String? = nil) -> AnyPublisher<T, Error> {
        network.delete(route, params: params, keypath: keypath)
    }
    
    // Array version
    func get<T: NetworkingJSONDecodable>(_ route: String,
                                         params: Params = Params(),
                                         keypath: String? = nil) -> AnyPublisher<[T], Error> {
        network.get(route, params: params, keypath: keypath)
    }
}
