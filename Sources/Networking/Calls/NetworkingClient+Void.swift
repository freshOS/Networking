//
//  NetworkingClient+Void.swift
//
//
//  Created by Sacha on 13/03/2020.
//

import Foundation
import Combine

public extension NetworkingClient {

    func post(_ route: String, body: HTTPBody? = nil) -> AnyPublisher<Void, Error> {
        post(route, body: body)
            .map { (data: Data) -> Void in () }
        .eraseToAnyPublisher()
    }
    
    func put(_ route: String, body: HTTPBody? = nil) -> AnyPublisher<Void, Error> {
        put(route, body: body)
            .map { (data: Data) -> Void in () }
            .eraseToAnyPublisher()
    }
    
    func patch(_ route: String, body: HTTPBody? = nil) -> AnyPublisher<Void, Error> {
        patch(route, body: body)
            .map { (data: Data) -> Void in () }
            .eraseToAnyPublisher()
    }

    func delete(_ route: String) -> AnyPublisher<Void, Error> {
        delete(route)
            .map { (data: Data) -> Void in () }
            .eraseToAnyPublisher()
    }
}