//
//  NetworkingRequest+Execute.swift
//
//
//  Created by Sacha DSO on 26/09/2024.
//

import Foundation

extension NetworkingClient {
    
    public func execute(request: NetworkingRequest) async throws -> Data {
        guard let urlRequest = request.buildURLRequest() else {
            throw NetworkingError.unableToParseRequest
        }
        logger.log(request: urlRequest, level: logLevel)
        let urlSession = URLSession(configuration: sessionConfiguration, delegate: sessionDelegate, delegateQueue: nil)
        let (data, response) = try await urlSession.data(for: urlRequest)
        logger.log(response: response, data: data, level: logLevel)
        if let httpURLResponse = response as? HTTPURLResponse, !(200...299 ~= httpURLResponse.statusCode) {
            var error = NetworkingError(errorCode: httpURLResponse.statusCode)
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                error.jsonPayload = JSON(jsonObject: json)
            }
            throw error
        }
        return data
    }
}
