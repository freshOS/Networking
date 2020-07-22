//
//  HttpBodyConvertable.swift
//  
//
//  Created by Jeff Barg on 07/22/2020.
//

import Foundation

public protocol HttpBodyConvertable {
    func buildHttpBody(boundary: String) -> Data
}
