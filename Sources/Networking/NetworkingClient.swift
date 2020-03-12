import Foundation
import Combine

public typealias Params = [String: CustomStringConvertible]


public struct NetworkingClient {
    
    /**
        Instead of using the same keypath for every call eg: "collection",
        this enables to use a default keypath for parsing collections.
        This is overidden by the per-request keypath if present.
     
     */
    public var defaultCollectionParsingKeyPath: String?
    let baseURL: String
    public var headers = [String: String]()

    /**
        Prints network calls to the console.
        Values Available are .None, Calls and CallsAndResponses.
        Default is None
    */
    public var logLevels: NetworkingLogLevel {
        get { return logger.logLevels }
        set { logger.logLevels = newValue }
    }
    
    private let logger = NetworkingLogger()
    
    public init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    private func defaultCall() -> NetworkingRequest {
        let r = NetworkingRequest()
        r.baseURL = baseURL
        r.logLevels = logLevels
        r.headers = headers
        return r
    }
    
    // Requests
    
    public func getRequest(_ route: String, params: Params = Params()) -> NetworkingRequest {
        let r = defaultCall()
        r.httpVerb = .get
        r.route = route
        r.params = params
        return r
    }
    
    public func postRequest(_ route: String, params: Params = Params()) -> NetworkingRequest {
        let r = defaultCall()
        r.httpVerb = .post
        r.route = route
        r.params = params
        return r
    }
    
    public func putRequest(_ route: String, params: Params = Params()) -> NetworkingRequest {
        let r = defaultCall()
        r.httpVerb = .put
        r.route = route
        r.params = params
        return r
    }
    
    public func deleteRequest(_ route: String, params: Params = Params()) -> NetworkingRequest {
        let r = defaultCall()
        r.httpVerb = .delete
        r.route = route
        r.params = params
        return r
    }
    
    // Data
    
    public func get(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
        getRequest(route, params: params).fetch()
    }
    
    public func post(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
        let r = defaultCall()
        r.httpVerb = .post
        r.route = route
        r.params = params
        return r.fetch()
    }
    
    public func put(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
        let r = defaultCall()
        r.httpVerb = .put
        r.route = route
        r.params = params
        return r.fetch()
    }
    
    // Multipart
    
    public func post(_ route: String, params: Params = Params(), multipartData: MultipartData) -> AnyPublisher<(Data?, Progress), Error> {
        let r = defaultCall()
        r.httpVerb = .post
        r.route = route
        r.params = params
        r.multipartData = multipartData
        return r.upload()
    }
    
    public func put(_ route: String, params: Params = Params(), multipartData: MultipartData) -> AnyPublisher<(Data?, Progress), Error> {
        let r = defaultCall()
        r.httpVerb = .put
        r.route = route
        r.params = params
        r.multipartData = multipartData
        return r.upload()
    }
    
    public func delete(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
        deleteRequest(route, params: params).fetch()
    }
    
    // Void
    public func get(_ route: String, params: Params = Params()) -> AnyPublisher<Void, Error> {
        let p: AnyPublisher<Data, Error> = get(route, params: params)
        return p.map { data -> Void in () }
        .eraseToAnyPublisher()
    }
    
    public func post(_ route: String, params: Params = Params()) -> AnyPublisher<Void, Error> {
        let p: AnyPublisher<Data, Error> = post(route, params: params)
        return p.map { data -> Void in () }
        .eraseToAnyPublisher()
    }
    
    public func put(_ route: String, params: Params = Params()) -> AnyPublisher<Void, Error> {
        let p: AnyPublisher<Data, Error> = put(route, params: params)
        return p.map { data -> Void in () }
        .eraseToAnyPublisher()
    }
    
    public func delete(_ route: String, params: Params = Params()) -> AnyPublisher<Void, Error> {
        let p: AnyPublisher<Data, Error> = delete(route, params: params)
        return p.map { data -> Void in () }
        .eraseToAnyPublisher()
    }
    
    // JSON
    
    public func get(_ route: String, params: Params = Params()) -> AnyPublisher<Any, Error> {
        get(route, params: params).toJSON()
    }
    
    public func post(_ route: String, params: Params = Params()) -> AnyPublisher<Any, Error> {
        post(route, params: params).toJSON()
    }
    
    public func put(_ route: String, params: Params = Params()) -> AnyPublisher<Any, Error> {
        put(route, params: params).toJSON()
    }
    
    public func delete(_ route: String, params: Params = Params()) -> AnyPublisher<Any, Error> {
        delete(route, params: params).toJSON()
    }
    
    // Private
    
//    private func request(_ route: String, httpVerb: HTTPVerb, params: Params) -> AnyPublisher<Data, Error> {
//        let urlString = baseURL + route
//        guard let url = URL(string: urlString) else {
//            return Fail(error: NetworkingError.init(httpStatusCode: -1)).eraseToAnyPublisher()
//        }
//        var urlRequest = URLRequest(url: url)
//        urlRequest.httpMethod = httpVerb.rawValue
//        logger.log(request: urlRequest)
//        return URLSession.shared.dataTaskPublisher(for: url)
//            .tryMap { (data: Data, response: URLResponse) -> Data in
//                self.logger.log(response: response, data: data)
//                if let httpURLResponse = response as? HTTPURLResponse {
//                    if !(200...299 ~= httpURLResponse.statusCode) {
//                        throw NetworkingError(httpStatusCode: httpURLResponse.statusCode)
//                    }
//                }
//            return data
//        }.mapError { e -> NetworkingError in
//            if let ne = e as? NetworkingError {
//                return ne
//            } else {
//                return NetworkingError.unableToParseResponse
//            }
//        }.receive(on: RunLoop.main).eraseToAnyPublisher()
//    }
}

// Data to JSON
extension Publisher where Output == Data {

    public func toJSON() -> AnyPublisher<Any, Error> {
        return self.tryMap { data -> Any in
            return try JSONSerialization.jsonObject(with: data, options: [])
        }.eraseToAnyPublisher()
    }
}



public protocol NetworkingService {
    
    var network: NetworkingClient! { get }
    
    func get<T: NetworkingJSONDecodable>(_ route: String,
                                                params: [String: CustomStringConvertible]?) -> AnyPublisher<T, Error>
}



extension NetworkingService {
    
    public func get<T: NetworkingJSONDecodable>(_ route: String,
                                      params: [String: CustomStringConvertible]? = nil) -> AnyPublisher<T, Error> {
        network.get(route, params: params ?? [String: CustomStringConvertible]())
    }
}
