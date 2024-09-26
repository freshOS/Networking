//
//  JSON.swift
//  Networking
//
//  Created by Sacha Durand Saint Omer on 26/09/2024.
//

import Foundation

public struct JSON: Sendable, CustomStringConvertible {
    
    let array: [any Sendable]?
    let dictionary: [String: any Sendable]?
    
    init(jsonObject: Any) {
        if let arr = jsonObject as? [Sendable] {
            array = arr
            dictionary = nil
        } else if let dic = jsonObject as? [String: any Sendable] {
            dictionary = dic
            array = nil
        } else {
            array = nil
            dictionary = nil
        }
    }
    
    var value: Any {
        return array ?? dictionary ?? ""
    }
    
    public var description: String {
        if let array = array {
            return String(describing: array)
        } else if let dictionary = dictionary {
            return String(describing: dictionary)
        }
        return "empty"
    }

}
