import Foundation
//import Combine

actor NetworkingClientURLSessionDelegate: NSObject, URLSessionDelegate {
    
//    let progressPublisher = PassthroughSubject<Progress, Error>()
    
    public func urlSession(_ session: URLSession,
                           task: URLSessionTask,
                           didSendBodyData bytesSent: Int64,
                           totalBytesSent: Int64,
                           totalBytesExpectedToSend: Int64) {
        let progress = Progress(totalUnitCount: totalBytesExpectedToSend)
        progress.completedUnitCount = totalBytesSent
//        progressPublisher.send(progress)
    }
}

// public typealias NetworkRequestRetrier = (_ request: URLRequest, _ error: Error) -> AnyPublisher<Void, Error>?

public actor NetworkingClient {
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
//    public var requestRetrier: NetworkRequestRetrier?
    public var jsonDecoderFactory: (() -> JSONDecoder)?

    let sessionDelegate = NetworkingClientURLSessionDelegate()
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
    
    public func toModel<T: NetworkingJSONDecodable>(_ json: JSON, keypath: String? = nil) throws -> T {
        do {
            let data = resourceData(from: json, keypath: keypath)
            return try T.decode(data)
        } catch (let error) {
            throw error
        }
    }
    
    public func toModel<T: Decodable>(_ json: JSON, keypath: String? = nil) throws -> T {
        do {
            let jsonObject = resourceData(from: json, keypath: keypath)
            let decoder = jsonDecoderFactory?() ?? JSONDecoder()
            let data = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
            let model = try decoder.decode(T.self, from: data)
            return model
        } catch (let error) {
            throw error
        }
    }

    public func toModels<T: NetworkingJSONDecodable>(_ json: JSON, keypath: String? = nil) throws -> [T] {
        do {
            guard let array = resourceData(from: json, keypath: keypath) as? [Any] else {
                return [T]()
            }
            return try array.map {
                try T.decode($0)
            }.compactMap { $0 }
        } catch (let error) {
            throw error
        }
    }
    
    public func toModels<T: Decodable>(_ json: JSON, keypath: String? = nil) throws -> [T] {
        do {
            guard let array = resourceData(from: json, keypath: keypath) as? [Any] else {
                return [T]()
            }
            return try array.map { jsonObject in
                let decoder = jsonDecoderFactory?() ?? JSONDecoder()
                let data = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
                let model = try decoder.decode(T.self, from: data)
                return model
            }.compactMap { $0 }
        } catch (let error) {
            throw error
        }
    }

    private func resourceData(from json: JSON, keypath: String?) -> Any {
        if let keypath = keypath, !keypath.isEmpty, let dic = json.dictionary, let val = dic[keypath] {
            return val is NSNull ? json.value : val
        }
        return json.value
    }
}
