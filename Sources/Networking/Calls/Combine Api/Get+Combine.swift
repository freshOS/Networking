//
//  Get+Combine.swift
//
//
//  Created by Sacha Durand Saint Omer on 12/11/2023.
//

import Foundation
import Combine

public extension NetworkingClient {
    
    func get(_ route: String, urlParams: Params? = nil) -> AnyPublisher<Void, Error> {
        get(route, urlParams: urlParams)
            .map { (data: Data) -> Void in () }
            .eraseToAnyPublisher()
    }
    
    func get(_ route: String, urlParams: Params? = nil) -> AnyPublisher<Data, Error> {
        request(.get, route, urlParams: urlParams).publisher()
    }
    
    func get(_ route: String, urlParams: Params? = nil) -> AnyPublisher<Any, Error> {
        get(route, urlParams: urlParams).toJSON()
    }
    
    func get<T: Decodable>(_ route: String,
                           urlParams: Params? = nil,
                           keypath: String? = nil) -> AnyPublisher<T, Error> {
        return get(route, urlParams: urlParams)
            .tryMap { json -> T in try self.toModel(json, keypath: keypath) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // Array version
    func get<T: Decodable>(_ route: String,
                           urlParams: Params? = nil,
                           keypath: String? = nil) -> AnyPublisher<T, Error> where T: Collection {
        let keypath = keypath ?? defaultCollectionParsingKeyPath
        return get(route, urlParams: urlParams)
            .tryMap { json -> T in try self.toModel(json, keypath: keypath) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
