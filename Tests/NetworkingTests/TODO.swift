//
//  TODO.swift
//  
//
//  Created by Sacha DSO on 30/01/2020.
//

import Foundation


// Networking Requirements.
// - No dependencies: Generics, Codable, Combine: Pure Native.
// - Leaves Models clean. ( Codable confromance can be made via an extension)
// - Simple to write.
// - Returns Publisher to be used with combine.
// - Favours composition, which is the essence of Combine's philosophy
// Can get Data, JSON (Any) or Model (Codable)

// Force explicit error handling SPECIFYING THE ERROR - return NetworkingError? instead of Error.


// Your Api error, you make the rules.
// the underlying NetworkingErrors should be bridged you your app-domain errors.
//enum ApiError: LocalizedError {
//    case callFailed
//}

// Post cannot be codable from another file
// this is very well explained here :
// https://forums.swift.org/t/why-you-cant-make-someone-elses-class-decodable-a-long-winded-explanation-of-required-initializers/6437
// extension Post: Codable {}
// For this reason it is advised to use a wrapper. Aka using and intermediary model conforming to Codable
// for mapping the JSON and then mapping to your original model, thus leaving your model clean and
// untouched by any Json parsing details.

//public protocol BackedByJSONModel {
//    associatedtype JSONModel: Decodable
//    static func fromJSONModel(jsonModel: JSONModel) -> Self
//}
