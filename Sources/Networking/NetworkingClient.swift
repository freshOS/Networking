import Foundation
import Combine


public typealias Params = [String: Any]

public struct NetworkingClient {
    
    let baseURL: String

    public var logLevels: NetworkingLogLevel {
        get { return logger.logLevels }
        set { logger.logLevels = newValue }
    }
    
    private let logger = NetworkingLogger()
    
    public init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    public func get(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
        return request(route, httpVerb: .get, params: params)
    }
    
    public func post(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
        return request(route, httpVerb: .post, params: params)
    }
    
    public func put(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
        return request(route, httpVerb: .put, params: params)
    }
    
    public func delete(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
        return request(route, httpVerb: .put, params: params)
    }
    
    // Private
    
    private func request(_ route: String, httpVerb: HTTPVerb, params: Params) -> AnyPublisher<Data, Error> {
        let urlString = baseURL + route
        guard let url = URL(string: urlString) else {
            return Fail(error: NetworkingError.init(httpStatusCode: -1)).eraseToAnyPublisher()
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpVerb.rawValue
        logger.log(request: urlRequest)
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { (data: Data, response: URLResponse) -> Data in
                self.logger.log(response: response, data: data)
                if let httpURLResponse = response as? HTTPURLResponse {
                    if !(200...299 ~= httpURLResponse.statusCode) {
                        throw NetworkingError(httpStatusCode: httpURLResponse.statusCode)
                    }
                }
            return data
        }.mapError { e -> NetworkingError in
            if let ne = e as? NetworkingError {
                return ne
            } else {
                return NetworkingError.unableToParseResponse
            }
        }.receive(on: RunLoop.main).eraseToAnyPublisher()
    }
}

public extension NetworkingClient {
//
//    func get(_ route: String, params: Params = Params()) -> AnyPublisher<Any, Error> {
//        return get(route).toJSON()
//    }
//
    func get<T: Decodable>(_ route: String, params: Params = Params()) -> AnyPublisher<T, Error> {
        return get(route, params: params).toModel()
    }
}

// Data to JSON
extension Publisher where Output == Data {

    public func toJSON() -> AnyPublisher<Any, Error> {
        return self.tryMap { data -> Any in
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            return json
        }.eraseToAnyPublisher()
    }
}

// Data to Model
extension Publisher where Output == Data {
    
    
    //test
    public func decode<T: Decodable>(_ type:T.Type) -> AnyPublisher<T, Error> {
        return decode(type: type, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    public func toModel<T: Decodable>() -> AnyPublisher<T, Error> {
        return toModel(T.self)
    }
    
    public func toModel<T: Decodable>(_ type:T.Type) -> AnyPublisher<T, Error> {
        return decode(type: type, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    public func toModels<T: Decodable>() -> AnyPublisher<[T], Error> {
        return toModels(T.self)
    }
    
    public func toModels<T: Decodable>(_ type:T.Type) -> AnyPublisher<[T], Error> {
        return toModel([T].self)
    }
}

//public extension NetworkingClient {
//
//    func get(route: String) -> AnyPublisher<Any, Error> {
//        return get(route).toJSON()
//    }
//    
//}


