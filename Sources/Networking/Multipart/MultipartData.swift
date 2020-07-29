//
//  MultipartData.swift
//  
//
//  Created by Sacha on 13/03/2020.
//

import Foundation

public struct MultipartData {
    let name: String
    let fileData: Data
    let fileName: String
    let mimeType: String

    public init(name: String, fileData: Data, fileName: String, mimeType: String) {
        self.name = name
        self.fileData = fileData
        self.fileName = fileName
        self.mimeType = mimeType
    }
}
