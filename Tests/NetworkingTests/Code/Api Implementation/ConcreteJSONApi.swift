//
//  File.swift
//  
//
//  Created by Sacha DSO on 30/01/2020.
//

import Foundation
import Networking
import Combine

struct ConcreteApi: Api, NetworkingService {
    
    let network: NetworkingClient = {
        var c = NetworkingClient(baseURL: "https://jsonplaceholder.typicode.com")
        c.logLevels = .debug
        return c
    }()
    
    func fetchPost() -> AnyPublisher<Post, Error> {
        get("/posts/1")
    }

    func fetchPosts() -> AnyPublisher<[Post], Error> {
        get("/posts")
    }
}


