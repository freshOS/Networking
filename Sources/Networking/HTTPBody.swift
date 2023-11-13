//
//  HTTPBody.swift
//
//
//  Created by Sacha Durand Saint Omer on 12/11/2023.
//

import Foundation

public enum HTTPBody {
    case urlEncoded(params: Params)
    case json(Encodable)
    case jsonParams(params: Params)
    case multipart(params: Params?, parts:[MultipartData])
}
