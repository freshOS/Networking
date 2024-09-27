//
//  NetworkingRequest+Execute.swift
//
//
//  Created by Sacha DSO on 26/09/2024.
//

import Foundation
import Combine


extension NetworkingClient {
    
    public func uploadPublisher(request: NetworkingRequest) -> AnyPublisher<(Data?, Progress), Error> {
        
        guard let urlRequest = request.buildURLRequest() else {
            return Fail(error: NetworkingError.unableToParseRequest as Error)
                .eraseToAnyPublisher()
        }
        logger.log(request: urlRequest)

        let urlSession = URLSession(configuration: sessionConfiguration, delegate: sessionDelegate, delegateQueue: nil)
        let callPublisher: AnyPublisher<(Data?, Progress), Error> = urlSession.dataTaskPublisher(for: urlRequest)
            .tryMap { (data: Data, response: URLResponse) -> Data in
                self.logger.log(response: response, data: data)
                if let httpURLResponse = response as? HTTPURLResponse {
                    if !(200...299 ~= httpURLResponse.statusCode) {
                        var error = NetworkingError(errorCode: httpURLResponse.statusCode)
                        if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                            error.jsonPayload = JSON(jsonObject: json)
                        }
                        throw error
                    }
                }
                return data
            }.mapError { error -> NetworkingError in
                return NetworkingError(error: error)
            }.map { data -> (Data?, Progress) in
                return (data, Progress())
            }.eraseToAnyPublisher()
        
        return callPublisher
            .eraseToAnyPublisher()
        // Todo put back progress
//
//        let progressPublisher2: AnyPublisher<(Data?, Progress), Error> = sessionDelegate.progressPublisher
//            .map { progress -> (Data?, Progress) in
//                return (nil, progress)
//            }.eraseToAnyPublisher()
//
//        return Publishers.Merge(callPublisher, progressPublisher2)
//            .receive(on: DispatchQueue.main)
//            .eraseToAnyPublisher()
    }

    public func publisher(request: NetworkingRequest) -> AnyPublisher<Data, Error> {
        publisher(request: request, retryCount: request.maxRetryCount)
    }

    private func publisher(request: NetworkingRequest, retryCount: Int) -> AnyPublisher<Data, Error> {
        guard let urlRequest = request.buildURLRequest() else {
            return Fail(error: NetworkingError.unableToParseRequest as Error)
                .eraseToAnyPublisher()
        }
        logger.log(request: urlRequest)

        let urlSession = URLSession(configuration: sessionConfiguration, delegate: sessionDelegate, delegateQueue: nil)
        return urlSession.dataTaskPublisher(for: urlRequest)
            .tryMap { (data: Data, response: URLResponse) -> Data in
                self.logger.log(response: response, data: data)
                if let httpURLResponse = response as? HTTPURLResponse {
                    if !(200...299 ~= httpURLResponse.statusCode) {
                        var error = NetworkingError(errorCode: httpURLResponse.statusCode)
                        if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                            error.jsonPayload = JSON(jsonObject: json)
                        }
                        throw error
                    }
                }
                return data
            }
        // TODO fix retry
//            .tryCatch({ [weak self, urlRequest] error -> AnyPublisher<Data, Error> in
//                guard
//                    let self = self,
//                    retryCount > 1,
//                    let retryPublisher = self.requestRetrier?(urlRequest, error)
//                else {
//                    throw error
//                }
//                return retryPublisher
//                    .flatMap { _ -> AnyPublisher<Data, Error> in
//                        self.publisher(request: request, retryCount: retryCount - 1)
//                    }
//                    .eraseToAnyPublisher()
//            })
            .mapError { error -> NetworkingError in
                return NetworkingError(error: error)
            }.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
}
