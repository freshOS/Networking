//
//  File.swift
//  
//
//  Created by Sacha DSO on 30/01/2020.
//

import Foundation
import Combine

// Generics Magick <3
// If the model asked for is Backed by a JSONModel
// Apply conversion automatically.
public extension NetworkingClient {

    func get<T: BackedByJSONModel>(_ route: String) -> AnyPublisher<T, Error> {
        return get(route).decode(type: T.JSONModel.self, decoder: JSONDecoder())
            .map(T.fromJSONModel)
            .eraseToAnyPublisher()
    }
}


// Array version
public extension NetworkingClient {

    func get<T: BackedByJSONModel>(_ route: String) -> AnyPublisher<[T], Error> {
        return get(route).decode(type: [T.JSONModel].self, decoder: JSONDecoder())
            .map { $0.map(T.fromJSONModel) }
            .eraseToAnyPublisher()
    }
}
