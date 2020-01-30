//
//  File.swift
//  
//
//  Created by Sacha DSO on 30/01/2020.
//

import Foundation
import Networking
import Combine

struct ConcreteJSONApi: Api {
    
    let client = NetworkingClient(baseURL: "https://jsonplaceholder.typicode.com")
    
    func fetchPost() -> AnyPublisher<Post, Error> {
        return client.get("/posts/1")
    }

    func fetchPosts() -> AnyPublisher<[Post], Error> {
        return client.get("/posts").toModels(Post.self)
    }
    
    func fetchCleanPost() -> AnyPublisher<CleanPost, Error> {
        return client.get("/posts/1")
    }
    
    func fetchCleanPosts() -> AnyPublisher<[CleanPost], Error> {
        return client.get("/posts")
    }

}


