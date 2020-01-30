//
//  Post.swift
//  
//
//  Created by Sacha DSO on 30/01/2020.
//

import Foundation


// Clean Model
// struct
// No default values
// only lets
// No protocol conformance. (not even Codable)

struct CleanPost {
    let id: Int
    let userId: Int
    let title: String
    let body: String
}

struct Post: Decodable {
    let id: Int
    let userId: Int
    let title: String
    let body: String
}
