//
//  HTTPBody.swift
//
//
//  Created by Sacha Durand Saint Omer on 12/11/2023.
//

import Foundation

public enum HTTPBody {
    case urlEncoded(params: Params)
    case json(_ encodable: Encodable)
    case multipart(params: Params? = nil, parts:[MultipartData])
}


extension HTTPBody {
    func header(for boundary: String) -> String {
        switch self {
        case .urlEncoded(_):
            return "application/x-www-form-urlencoded"
        case .json(_):
            return "application/json"
        case .multipart(_, _):
            return "multipart/form-data; boundary=\(boundary)"
        }
    }
}

extension HTTPBody {
    
    func body(for boundary: String) -> Data? {
        switch self {
        case .urlEncoded(params: let params):
            return params.asPercentEncodedString().data(using: .utf8)
        case .json(let encodable):
            do {
                let jsonEncoder = JSONEncoder()
                let data = try jsonEncoder.encode(encodable)
                return data
            } catch {
                print(error)
                return nil
            }
        case .multipart(params: let params, parts: let parts):
            return buildMultipartHttpBody(params: params ?? [:], multiparts: parts, boundary: boundary)
        }
    }
    
    private func buildMultipartHttpBody(params: Params, multiparts: [MultipartData], boundary: String) -> Data {
        // Combine all multiparts together
        let allMultiparts: [HttpBodyConvertible] = [params] + multiparts
        let boundaryEnding = "--\(boundary)--".data(using: .utf8)!
        
        // Convert multiparts to boundary-seperated Data and combine them
        return allMultiparts
            .map { (multipart: HttpBodyConvertible) -> Data in
                return multipart.buildHttpBodyPart(boundary: boundary)
            }
            .reduce(Data.init(), +)
            + boundaryEnding
    }
}
    
