//
//  NetworkingRequest.swift
//
//: URLSessionDelegate
//  Created by Sacha DSO on 21/02/2020.
//

import Foundation
import Combine

public struct NetworkingRequest {
    
    let httpMethod: HTTPMethod
    let baseURL: String
    let route: String
    let params: Params
    let parameterEncoding: ParameterEncoding
    let headers: [String: String]
    let multipartData: [MultipartData]?
    let timeout: TimeInterval?
    let progressPublisher = PassthroughSubject<Progress, Error>()
    var requestRetrier: NetworkRequestRetrier?
    internal let maxRetryCount = 3
    
}

public typealias NetworkRequestRetrier = (_ request: URLRequest, _ error: Error) -> AnyPublisher<Void, Error>?
