//
//  Post.swift
//  
//
//  Created by Sacha DSO on 30/01/2020.
//

import Foundation

struct Post: Decodable {
    let id: Int
    let userId: Int
    let title: String
    let body: String
}
