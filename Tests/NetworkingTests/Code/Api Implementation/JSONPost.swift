//
//  File.swift
//  
//
//  Created by Sacha DSO on 30/01/2020.
//

import Foundation
import Networking

struct JSONPost: Decodable {
    let id: Int
    let userId: Int
    let title: String
    let body: String
}

// JSON:
//{
//  "userId": 1,
//  "id": 1,
//  "title": "delectus aut autem",
//  "completed": false
//}

