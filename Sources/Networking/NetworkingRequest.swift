//
//  NetworkingRequest.swift
//
//
//  Created by Sacha DSO on 21/02/2020.
//

import Foundation
@preconcurrency import Combine





public struct NetworkingRequest {
    let method: HTTPMethod
    let url: String
    let parameterEncoding: ParameterEncoding
    let params: Params
    let encodableBody: Encodable?
    let headers: [String: String]
    let multipartData: [MultipartData]?
    let timeout: TimeInterval?
    let maxRetryCount = 3
//    var logLevel: NetworkingLogLevel {
//        get { return logger.logLevel }
//        set { logger.logLevel = newValue }
//    }
}

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
    
    func execute(request: NetworkingRequest) async throws -> Data {
        guard let urlRequest = request.buildURLRequest() else {
            throw NetworkingError.unableToParseRequest
        }
        logger.log(request: urlRequest)
        let urlSession = URLSession(configuration: sessionConfiguration, delegate: sessionDelegate, delegateQueue: nil)
        let (data, response) = try await urlSession.data(for: urlRequest)
        logger.log(response: response, data: data)
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

// Thansks to https://stackoverflow.com/questions/26364914/http-request-in-swift-with-post-method
extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}

public enum ParameterEncoding {
    case urlEncoded
    case json
}


extension NetworkingRequest {
    internal func buildURLRequest() -> URLRequest? {
        var urlString = url
        if method == .get {
            urlString = getURLWithParams()
        }
        
        guard let url = URL(string: urlString) else {
            return nil
        }
        var request = URLRequest(url: url)
        
        if method != .get && multipartData == nil {
            switch parameterEncoding {
            case .urlEncoded:
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            case .json:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        }
        
        request.httpMethod = method.rawValue
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        if let timeout = timeout {
            request.timeoutInterval = timeout
        }
        
        if method != .get && multipartData == nil {
            if let encodableBody {
                let jsonEncoder = JSONEncoder()
                do {
                    let data = try jsonEncoder.encode(encodableBody)
                    request.httpBody = data
                } catch {
                    print(error)
                }
            } else {
                switch parameterEncoding {
                case .urlEncoded:
                    request.httpBody = params.asPercentEncodedString().data(using: .utf8)
                case .json:
                    let jsonData = try? JSONSerialization.data(withJSONObject: params)
                    request.httpBody = jsonData
                }
            }
        }
        
        // Multipart
        if let multiparts = multipartData {
            // Construct a unique boundary to separate values
            let boundary = "Boundary-\(UUID().uuidString)"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.httpBody = buildMultipartHttpBody(params: params, multiparts: multiparts, boundary: boundary)
        }
        return request
    }
    
    private func getURLWithParams() -> String {
        let urlString = url
        if params.isEmpty { return urlString }
        guard let url = URL(string: urlString) else {
            return urlString
        }
        if var urlComponents = URLComponents(url: url ,resolvingAgainstBaseURL: false) {
            var queryItems = urlComponents.queryItems ?? [URLQueryItem]()
            params.forEach { param in
                // arrayParam[] syntax
                if let array = param.value as? [CustomStringConvertible] {
                    array.forEach {
                        queryItems.append(URLQueryItem(name: "\(param.key)[]", value: "\($0)"))
                    }
                }
                queryItems.append(URLQueryItem(name: param.key, value: "\(param.value)"))
            }
            urlComponents.queryItems = queryItems
            return urlComponents.url?.absoluteString ?? urlString
        }
        return urlString
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
