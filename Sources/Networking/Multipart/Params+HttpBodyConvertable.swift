//
//  Params+HttpBodyConvertable.swift
//  
//
//  Created by Jeff Barg on 07/22/2020.
//

import Foundation

extension Params: HttpBodyConvertable {
    public func buildHttpBody(boundary: String) -> Data {
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

fileprivate extension NSMutableData {
    func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}
