//
//  NetworkingRequest.swift
//
//
//  Created by Sacha DSO on 21/02/2020.
//

import Foundation
import Combine


public typealias NetworkRequestRetrier = (_ request: URLRequest, _ error: Error) -> AnyPublisher<Void, Error>?

public class NetworkingRequest: NSObject, URLSessionTaskDelegate {
    
    var baseURL = ""
    var route = ""
    var httpMethod = HTTPMethod.get
    var httpBody: HTTPBody? = nil
    public var params: Params = Params()
    var headers = [String: String]()
    var logLevel: NetworkingLogLevel {
        get { return logger.logLevel }
        set { logger.logLevel = newValue }
    }
    private let logger = NetworkingLogger()
    var timeout: TimeInterval?
    let progressPublisher = PassthroughSubject<Progress, Error>()
    var sessionConfiguration: URLSessionConfiguration?
    var requestRetrier: NetworkRequestRetrier?
    private let maxRetryCount = 3

    public func uploadPublisher() -> AnyPublisher<(Data?, Progress), Error> {
        
        guard let urlRequest = buildURLRequest() else {
            return Fail(error: NetworkingError.unableToParseRequest as Error)
                .eraseToAnyPublisher()
        }
        logger.log(request: urlRequest)

        let config = sessionConfiguration ?? URLSessionConfiguration.default
        let urlSession = URLSession(configuration: config, delegate: self, delegateQueue: nil)
        let callPublisher: AnyPublisher<(Data?, Progress), Error> = urlSession.dataTaskPublisher(for: urlRequest)
            .tryMap { (data: Data, response: URLResponse) -> Data in
                self.logger.log(response: response, data: data)
                if let httpURLResponse = response as? HTTPURLResponse {
                    if !(200...299 ~= httpURLResponse.statusCode) {
                        var error = NetworkingError(errorCode: httpURLResponse.statusCode)
                        if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                            error.jsonPayload = json
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
        
        let progressPublisher2: AnyPublisher<(Data?, Progress), Error> = progressPublisher
            .map { progress -> (Data?, Progress) in
                return (nil, progress)
            }.eraseToAnyPublisher()
        
        return Publishers.Merge(callPublisher, progressPublisher2)
            .receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }

    public func publisher() -> AnyPublisher<Data, Error> {
        publisher(retryCount: maxRetryCount)
    }

    private func publisher(retryCount: Int) -> AnyPublisher<Data, Error> {
        guard let urlRequest = buildURLRequest() else {
            return Fail(error: NetworkingError.unableToParseRequest as Error)
                .eraseToAnyPublisher()
        }
        logger.log(request: urlRequest)

        let config = sessionConfiguration ?? URLSessionConfiguration.default
        let urlSession = URLSession(configuration: config, delegate: self, delegateQueue: nil)
        return urlSession.dataTaskPublisher(for: urlRequest)
            .tryMap { (data: Data, response: URLResponse) -> Data in
                self.logger.log(response: response, data: data)
                if let httpURLResponse = response as? HTTPURLResponse {
                    if !(200...299 ~= httpURLResponse.statusCode) {
                        var error = NetworkingError(errorCode: httpURLResponse.statusCode)
                        if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                            error.jsonPayload = json
                        }
                        throw error
                    }
                }
                return data
            }.tryCatch({ [weak self, urlRequest] error -> AnyPublisher<Data, Error> in
                guard
                    let self = self,
                    retryCount > 1,
                    let retryPublisher = self.requestRetrier?(urlRequest, error)
                else {
                    throw error
                }
                return retryPublisher
                    .flatMap { _ -> AnyPublisher<Data, Error> in
                        self.publisher(retryCount: retryCount - 1)
                    }
                    .eraseToAnyPublisher()
            }).mapError { error -> NetworkingError in
                return NetworkingError(error: error)
            }.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    
    func execute() async throws -> Data {
        guard let urlRequest = buildURLRequest() else {
            throw NetworkingError.unableToParseRequest
        }
        logger.log(request: urlRequest)
        let config = sessionConfiguration ?? URLSessionConfiguration.default
        let urlSession = URLSession(configuration: config, delegate: self, delegateQueue: nil)
        let (data, response) = try await urlSession.data(for: urlRequest)
        self.logger.log(response: response, data: data)
        if let httpURLResponse = response as? HTTPURLResponse, !(200...299 ~= httpURLResponse.statusCode) {
            var error = NetworkingError(errorCode: httpURLResponse.statusCode)
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                error.jsonPayload = json
            }
            throw error
        }
        return data
        
    }
    
    private func getURLWithParams() -> String {
        let urlString = baseURL + route
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
    
    internal func buildURLRequest() -> URLRequest? {
        var urlString = baseURL + route
        if httpMethod == .get {
            urlString = getURLWithParams()
        }
        
        guard let url = URL(string: urlString) else {
            return nil
        }
        var request = URLRequest(url: url)
        
        
        request.httpMethod = httpMethod.rawValue
        
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        if let timeout {
            request.timeoutInterval = timeout
        }
    
        if let httpBody {
            let boundary = "Boundary-\(UUID().uuidString)"
            request.setValue(httpBody.header(for: boundary), forHTTPHeaderField: "Content-Type")
            request.httpBody = httpBody.body(for: boundary)
        }
        
        return request
    }
    
    public func urlSession(_ session: URLSession,
                           task: URLSessionTask,
                           didSendBodyData bytesSent: Int64,
                           totalBytesSent: Int64,
                           totalBytesExpectedToSend: Int64) {
        let progress = Progress(totalUnitCount: totalBytesExpectedToSend)
        progress.completedUnitCount = totalBytesSent
        progressPublisher.send(progress)
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
