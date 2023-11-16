//
//  NetworkingClient+JSON.swift
//
//
//  Created by Sacha on 13/03/2020.
//

import Foundation
import Combine

// Data to JSON
extension Publisher where Output == Data {

    public func toJSON() -> AnyPublisher<Any, Error> {
         tryMap { data -> Any in
            return try JSONSerialization.jsonObject(with: data, options: [])
        }.eraseToAnyPublisher()
    }
}
