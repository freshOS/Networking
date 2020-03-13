//
//  Api.swift
//  
//
//  Created by Sacha DSO on 30/01/2020.
//

import Foundation
import Combine

// Your async api not depending on any networking details (http etc)
protocol Api {
    func fetchPost() -> AnyPublisher<Post, Error>
    func fetchPosts() -> AnyPublisher<[Post], Error>
}
