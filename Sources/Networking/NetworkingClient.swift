import Foundation
import Combine

public class NetworkingClient: NSObject, URLSessionDelegate {
    /**
     Instead of using the same keypath for every call eg: "collection",
     this enables to use a default keypath for parsing collections.
     This is overridden by the per-request keypath if present.
     
     */
    public var defaultCollectionParsingKeyPath: String?
    let baseURL: String
    public var headers = [String: String]()
    public var parameterEncoding = ParameterEncoding.urlEncoded
    public var timeout: TimeInterval?
    public var sessionConfiguration = URLSessionConfiguration.default
    public var requestRetrier: NetworkRequestRetrier?
    
    /**
     Prints network calls to the console.
     Values Available are .None, Calls and CallsAndResponses.
     Default is None
     */
    public var logLevel: NetworkingLogLevel {
        get { return logger.logLevel }
        set { logger.logLevel = newValue }
    }
    
    internal let logger = NetworkingLogger()
    
    public init(baseURL: String, timeout: TimeInterval? = nil) {
        self.baseURL = baseURL
        self.timeout = timeout
    }
    
    internal func request(_ httpMethod: HTTPMethod,
                          _ route: String,
                          params: Params = Params(),
                          multipartData:  [MultipartData]? = nil) -> NetworkingRequest {
        
        //        let requestRetrier: NetworkRequestRetrier = { (_ request: URLRequest, _ error: Error) -> AnyPublisher<Void, Error>? in
        //            //TODO put back
        ////            self?.requestRetrier?($0, $1)?
        ////                .handleEvents(receiveOutput: { _ in
        ////                    updateRequest()
        ////                })
        ////                .eraseToAnyPublisher()
        //            return nil
        //        }
        return NetworkingRequest(
            httpMethod: httpMethod,
            baseURL: baseURL,
            route: route,
            params: params,
            parameterEncoding: parameterEncoding,
            headers: headers,
            multipartData: multipartData,
            timeout: timeout,
            requestRetrier: nil)
    }
    
    func publisher(for request: NetworkingRequest) -> AnyPublisher<Data, Error> {
        publisher(for: request, retryCount: request.maxRetryCount)
    }
    
    private func publisher(for request: NetworkingRequest, retryCount: Int) -> AnyPublisher<Data, Error> {
        guard let urlRequest = request.buildURLRequest() else {
            return Fail(error: NetworkingError.unableToParseRequest as Error)
                .eraseToAnyPublisher()
        }
        logger.log(request: urlRequest)
        
        let urlSession = URLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: nil)
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
                        self.publisher(for: request, retryCount: retryCount - 1)
                    }
                    .eraseToAnyPublisher()
            }).mapError { error -> NetworkingError in
                return NetworkingError(error: error)
            }.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    
    func execute(request: NetworkingRequest) async throws -> Data {
        guard let urlRequest = request.buildURLRequest() else {
            throw NetworkingError.unableToParseRequest
        }
        logger.log(request: urlRequest)
        
        return try await withCheckedThrowingContinuation { continuation in
            let urlSession = URLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: nil)
            urlSession.dataTask(with: urlRequest) { data, response, error in
                guard let data = data, let response = response else {
                    if let error = error {
                        continuation.resume(throwing: error)
                    }
                    return
                }
                self.logger.log(response: response, data: data)
                if let httpURLResponse = response as? HTTPURLResponse {
                    if !(200...299 ~= httpURLResponse.statusCode) {
                        var error = NetworkingError(errorCode: httpURLResponse.statusCode)
                        if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                            error.jsonPayload = json
                        }
                        continuation.resume(throwing: error)
                        return
                    }
                }
                continuation.resume(returning: data)
            }.resume()
        }
    }
    
    func uploadPublisher(for request: NetworkingRequest) -> AnyPublisher<(Data?, Progress), Error> {
        
        guard let urlRequest = request.buildURLRequest() else {
            return Fail(error: NetworkingError.unableToParseRequest as Error)
                .eraseToAnyPublisher()
        }
        logger.log(request: urlRequest)
        
        let urlSession = URLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: nil)
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
        
        let progressPublisher2: AnyPublisher<(Data?, Progress), Error> = request.progressPublisher
            .map { progress -> (Data?, Progress) in
                return (nil, progress)
            }.eraseToAnyPublisher()
        
        return Publishers.Merge(callPublisher, progressPublisher2)
            .receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
}


extension NetworkingClient: URLSessionTaskDelegate {
    public func urlSession(_ session: URLSession,
                           task: URLSessionTask,
                           didSendBodyData bytesSent: Int64,
                           totalBytesSent: Int64,
                           totalBytesExpectedToSend: Int64) {
        let progress = Progress(totalUnitCount: totalBytesExpectedToSend)
        progress.completedUnitCount = totalBytesSent
        //        progressPublisher.send(progress) //TODO
    }
}
