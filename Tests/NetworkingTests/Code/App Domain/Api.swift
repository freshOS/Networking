//
//  Api.swift
//  
//
//  Created by Sacha DSO on 30/01/2020.
//

import Foundation
import Combine

// Your asyn api not depending on any networking details (http etc)
protocol Api {
    func fetchPost() -> AnyPublisher<Post, Error>
    func fetchPosts() -> AnyPublisher<[Post], Error>
    
    // Clean posts where Post cannot be decodable for some reason.
    // Because you dont have access to it or you don't want to "pollute"
    // your model with parsing logic.
    func fetchCleanPost() -> AnyPublisher<CleanPost, Error>
    func fetchCleanPosts() -> AnyPublisher<[CleanPost], Error>
}

// Your Api error, you make the rules.
// the underlying NetworkingErrors should be bridged you your app-domain errors.
enum ApiError: LocalizedError {
    case callFailed
}
