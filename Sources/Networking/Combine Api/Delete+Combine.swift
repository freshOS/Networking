//
//  Delete+Combine.swift
//
//
//  Created by Sacha Durand Saint Omer on 12/11/2023.
//

import Foundation
import Combine

public extension NetworkingClient {
    
    func delete(_ route: String) -> AnyPublisher<Void, Error> {
        delete(route)
            .map { (data: Data) -> Void in () }
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
    
    func delete(_ route: String) -> AnyPublisher<Any, Error> {
        delete(route).toJSON()
    }
    
    func delete(_ route: String) -> AnyPublisher<Data, Error> {
        request(.delete, route).publisher()
    }
}

public extension NetworkingService {
    
    func delete(_ route: String) -> AnyPublisher<Void, Error> {
        network.delete(route)
    }
    
    func delete<T: Decodable>(_ route: String,
                              keypath: String? = nil) -> AnyPublisher<T, Error> {
        network.delete(route, keypath: keypath)
    }
    
    func delete<T: Decodable>(_ route: String,
                              params: Params = Params(),
                              keypath: String? = nil) -> AnyPublisher<T, Error> where T: Collection {
        network.delete(route, keypath: keypath)
    }
    
    func delete<T: NetworkingJSONDecodable>(_ route: String,
                                            keypath: String? = nil) -> AnyPublisher<T, Error> {
        network.delete(route, keypath: keypath)
    }
    
    func delete<T: NetworkingJSONDecodable>(_ route: String,
                                            keypath: String? = nil) -> AnyPublisher<[T], Error> {
        network.delete(route, keypath: keypath)
    }
    
    func delete(_ route: String) -> AnyPublisher<Any, Error> {
        network.delete(route)
    }
    
    func delete(_ route: String) -> AnyPublisher<Data, Error> {
        network.delete(route)
    }
}

