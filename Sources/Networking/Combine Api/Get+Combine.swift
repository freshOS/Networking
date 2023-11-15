//
//  Get+Combine.swift
//
//
//  Created by Sacha Durand Saint Omer on 12/11/2023.
//

import Foundation
import Combine

public extension NetworkingClient {
    
    func get(_ route: String, params: Params? = nil) -> AnyPublisher<Void, Error> {
        get(route, params: params)
            .map { (data: Data) -> Void in () }
            .eraseToAnyPublisher()
    }
    
    func get<T: Decodable>(_ route: String,
                           params: Params? = nil,
                           keypath: String? = nil) -> AnyPublisher<T, Error> {
        return get(route, params: params)
            .tryMap { json -> T in try self.toModel(json, keypath: keypath) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // Array version
    func get<T: Decodable>(_ route: String,
                           params: Params? = nil,
                           keypath: String? = nil) -> AnyPublisher<T, Error> where T: Collection {
        let keypath = keypath ?? defaultCollectionParsingKeyPath
        return get(route, params: params)
            .tryMap { json -> T in try self.toModel(json, keypath: keypath) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func get(_ route: String, params: Params? = nil) -> AnyPublisher<Any, Error> {
        get(route, params: params).toJSON()
    }
    
    func get(_ route: String, params: Params? = nil) -> AnyPublisher<Data, Error> {
        request(.get, route, params: params).publisher()
    }
}

public extension NetworkingService {
    
    func get(_ route: String, params: Params? = nil) -> AnyPublisher<Void, Error> {
        network.get(route, params: params)
    }
    
    func get<T: Decodable>(_ route: String,
                           params: Params? = nil,
                           keypath: String? = nil) -> AnyPublisher<T, Error> {
        network.get(route, params: params, keypath: keypath)
    }
    
    func get<T: Decodable>(_ route: String,
                           params: Params? = nil,
                           keypath: String? = nil) -> AnyPublisher<T, Error> where T: Collection {
        network.get(route, params: params, keypath: keypath)
    }
    
    func get<T: NetworkingJSONDecodable>(_ route: String,
                                         params: Params? = nil,
                                         keypath: String? = nil) -> AnyPublisher<T, Error> {
        network.get(route, params: params, keypath: keypath)
    }
    
    func get<T: NetworkingJSONDecodable>(_ route: String,
                                         params: Params? = nil,
                                         keypath: String? = nil) -> AnyPublisher<[T], Error> {
        network.get(route, params: params, keypath: keypath)
    }
    
    
    func get(_ route: String, params: Params? = nil) -> AnyPublisher<Any, Error> {
        network.get(route, params: params)
    }
    
    func get(_ route: String, params: Params? = nil) -> AnyPublisher<Data, Error> {
        network.get(route, params: params)
    }
    
    
    
}
