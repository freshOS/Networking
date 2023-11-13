//
//  Patch+Combine.swift
//  
//
//  Created by Sacha Durand Saint Omer on 12/11/2023.
//

import Foundation
import Combine

public extension NetworkingClient {
    
    func patch(_ route: String, body: HTTPBody? = nil) -> AnyPublisher<Void, Error> {
        patch(route, body: body)
            .map { (data: Data) -> Void in () }
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
    
    func patch(_ route: String, body: HTTPBody? = nil) -> AnyPublisher<Any, Error> {
        patch(route, body: body).toJSON()
    }
    
    func patch(_ route: String, body: HTTPBody? = nil) -> AnyPublisher<Data, Error> {
        request(.patch, route, body: body).publisher()
    }
    
    func patch(_ route: String,
             body: HTTPBody) -> AnyPublisher<(Data?, Progress), Error> {
        let req = request(.patch, route, body: body)
        return req.uploadPublisher()
    }
}
