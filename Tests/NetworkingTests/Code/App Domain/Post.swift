//
//  Post.swift
//  
//
//  Created by Sacha DSO on 30/01/2020.
//

import Foundation

struct Post: Decodable {
    let identifier: Int
    let userId: Int
    let title: String
    let body: String

    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case userId
        case title
        case body
    }
}
