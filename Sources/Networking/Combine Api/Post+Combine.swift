//
//  Post+Combine.swift
//
//
//  Created by Sacha Durand Saint Omer on 12/11/2023.
//

import Foundation
import Combine

public extension NetworkingClient {
    
    func post(_ route: String, body: HTTPBody? = nil) -> AnyPublisher<Void, Error> {
        post(route, body: body)
            .map { (data: Data) -> Void in () }
            .eraseToAnyPublisher()
    }
    
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
    
    func post(_ route: String, body: HTTPBody? = nil) -> AnyPublisher<Any, Error> {
        post(route, body: body).toJSON()
    }
    
    func post(_ route: String, body: HTTPBody? = nil) -> AnyPublisher<Data, Error> {
        request(.post, route, body: body).publisher()
    }
    
    func post(_ route: String,
              body: HTTPBody) -> AnyPublisher<(Data?, Progress), Error> {
        let req = request(.post, route, body: body)
        return req.uploadPublisher()
    }
    
}

public extension NetworkingService {
    
    func post(_ route: String, body: HTTPBody? = nil) -> AnyPublisher<Void, Error> {
        network.post(route, body: body)
    }
    
    func post<T: Decodable>(_ route: String,
                            body: HTTPBody? = nil,
                            keypath: String? = nil) -> AnyPublisher<T, Error> {
        network.post(route, body: body, keypath: keypath)
    }
    
    func post<T: Decodable>(_ route: String,
                            body: HTTPBody? = nil,
                            keypath: String? = nil) -> AnyPublisher<T, Error> where T: Collection {
        network.post(route, body: body, keypath: keypath)
    }
    
    func post<T: NetworkingJSONDecodable>(_ route: String,
                                          body: HTTPBody? = nil,
                                          keypath: String? = nil) -> AnyPublisher<T, Error> {
        network.post(route, body: body, keypath: keypath)
    }
    
    func post<T: NetworkingJSONDecodable>(_ route: String,
                                          body: HTTPBody? = nil,
                                          keypath: String? = nil) -> AnyPublisher<[T], Error> {
        network.post(route, body: body, keypath: keypath)
    }
    
    func post(_ route: String, body: HTTPBody? = nil) -> AnyPublisher<Any, Error> {
        network.post(route, body: body)
    }
    
    func post(_ route: String, body: HTTPBody? = nil) -> AnyPublisher<Data, Error> {
        network.post(route, body: body)
    }
}
