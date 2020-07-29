//
//  Params+HttpBodyConvertable.swift
//  
//
//  Created by Jeff Barg on 07/22/2020.
//

import Foundation

extension Params: HttpBodyConvertable {
    public func buildHttpBodyPart(boundary: String) -> Data {
        let httpBody = NSMutableData()

        self.forEach { (name, value) in
            httpBody.appendString("--\(boundary)\r\n")
            httpBody.appendString("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n")
            httpBody.appendString(value.description)
            httpBody.appendString("\r\n")
        }
        
        return httpBody as Data
    }
}
