//
//  BackedByJSONModel.swift
//  
//
//  Created by Sacha DSO on 30/01/2020.
//

import Foundation

// Post cannot be codable from another file
// this is very well explained here :
// https://forums.swift.org/t/why-you-cant-make-someone-elses-class-decodable-a-long-winded-explanation-of-required-initializers/6437
// extension Post: Codable {}
// For this reason it is advised to use a wrapper. Aka using and intermediary model conforming to Codable
// for mapping the JSON and then mapping to your original model, thus leaving your model clean and
// untouched by any Json parsing details.

public protocol BackedByJSONModel {
    associatedtype JSONModel: Decodable
    static func fromJSONModel(jsonModel: JSONModel) -> Self
}
