//
//  JSONPost.swift
//  
//
//  Created by Sacha DSO on 30/01/2020.
//

import Foundation
import Networking

struct JSONPost: Decodable {
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

/*
JSON:
{
  "userId": 1,
  "id": 1,
  "title": "delectus aut autem",
  "completed": false
}
*/
