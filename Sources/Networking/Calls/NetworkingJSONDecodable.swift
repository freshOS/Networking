//
//  NetworkingJSONDecodable.swift
//  Networking
//
//  Created by Sacha Durand Saint Omer on 26/09/2024.
//

import Foundation

public protocol NetworkingJSONDecodable {
    /// The method you declare your JSON mapping in.
    static func decode(_ json: Any) throws -> Self
}
