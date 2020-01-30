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

// Declare that your clean model is backed by a JSONModel and define how it maps back to your clean model.
extension CleanPost: BackedByJSONModel {
    
    static func fromJSONModel(jsonModel: JSONPost) -> CleanPost {
        CleanPost(id: jsonModel.id, userId: jsonModel.userId, title: jsonModel.title, body: jsonModel.body)
    }
}
