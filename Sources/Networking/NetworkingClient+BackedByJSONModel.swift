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


public protocol NetworkingJSONDecodable {
    /// Makes sure your models can be constructed with an empty constructor.
    init()
    /// The method you declare your JSON mapping in.
    mutating func decode(_ json: Any)
}


extension NetworkingClient {
    
    // Single
    public func get<T: NetworkingJSONDecodable>(_ route: String,
                                      params: Params = Params(),
                                      keypath: String? = nil) -> AnyPublisher<T, Error> {
        return get(route, params: params)
            .map { json -> T in NetworkingParser().toModel(json, keypath: keypath) }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    // Single
    public func post<T: NetworkingJSONDecodable>(_ route: String,
                                      params: Params = Params(),
                                      keypath: String? = nil) -> AnyPublisher<T, Error> {
        return post(route, params: params)
            .map { json -> T in NetworkingParser().toModel(json, keypath: keypath) }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    // Array
    public func get<T: NetworkingJSONDecodable>(_ route: String,
                                      params: Params = Params(),
                                      keypath: String? = nil) -> AnyPublisher<[T], Error> {
        let keypath = keypath ?? defaultCollectionParsingKeyPath
        return get(route, params: params)
            .map { json -> [T] in  NetworkingParser().toModels(json, keypath: keypath) }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}

public struct NetworkingParser {
    
    public init() {}

    public func toModel<T: NetworkingJSONDecodable>(_ json: Any, keypath: String? = nil) -> T {
        let data = resourceData(from: json, keypath: keypath)
        return resource(from: data)
    }

    public func toModels<T: NetworkingJSONDecodable>(_ json: Any, keypath: String? = nil) -> [T] {
        guard let array = resourceData(from: json, keypath: keypath) as? [Any] else {
            return [T]()
        }
        return array.map {
            resource(from: $0)
        }
    }

    private func resource<T: NetworkingJSONDecodable>(from json: Any) -> T {
        var t = T()
        t.decode(json)
        return t
    }

    private func resourceData(from json: Any, keypath: String?) -> Any {
        if let k = keypath, !k.isEmpty,  let dic = json as? [String: Any], let j = dic[k] {
            return j
        }
        return json
    }
}

