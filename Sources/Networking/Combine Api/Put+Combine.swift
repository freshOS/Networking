//
//  Put+Combine.swift
//
//
//  Created by Sacha Durand Saint Omer on 12/11/2023.
//

import Foundation
import Combine

public extension NetworkingClient {
    
    func put(_ route: String, body: HTTPBody? = nil) -> AnyPublisher<Void, Error> {
        put(route, body: body)
            .map { (data: Data) -> Void in () }
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
    
    func put(_ route: String,  body: HTTPBody? = nil) -> AnyPublisher<Any, Error> {
        put(route, body: body).toJSON()
    }
    
    func put(_ route: String, body: HTTPBody? = nil) -> AnyPublisher<Data, Error> {
        request(.put, route, body: body).publisher()
    }
    
    func put(_ route: String,
             body: HTTPBody) -> AnyPublisher<(Data?, Progress), Error> {
        let req = request(.put, route, body: body)
        return req.uploadPublisher()
    }
}
