import Foundation
import Combine

public enum HTTPVerb: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}


public struct NetworkingClient {
    
    let baseURL: String
    
    public init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    public func get(_ route: String) -> AnyPublisher<Data, Error> {
        let urlString = baseURL + route
        let url = URL(string: urlString)!
        let publisher = URLSession.shared.dataTaskPublisher(for: url)
        return publisher.map { (data: Data, response: URLResponse) -> Data in
//            print(data)
//            print(response)
            return data
        }.mapError { urlError -> Error in
            print(urlError)
            return NSError() as Error
        }.eraseToAnyPublisher()
    }
    
    public func post(_ route: String) -> AnyPublisher<Data, Error> {
        let urlString = baseURL + route
        let url = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPVerb.post.rawValue
        let publisher = URLSession.shared.dataTaskPublisher(for: urlRequest)
        return publisher.map { (data: Data, response: URLResponse) -> Data in
//            print(data)
//            print(response)
            return data
        }.mapError { urlError -> Error in
            print(urlError)
            return NSError() as Error
        }.eraseToAnyPublisher()
    }
    
    private func request(_ route: String) -> AnyPublisher<Data, Error> {
        let urlString = baseURL + route
        let url = URL(string: urlString)!
        let publisher = URLSession.shared.dataTaskPublisher(for: url)
        return publisher.map { (data: Data, response: URLResponse) -> Data in
//            print(data)
//            print(response)
            return data
        }.mapError { urlError -> Error in
            print(urlError)
            return NSError() as Error
        }.eraseToAnyPublisher()
    }
    

}

public extension NetworkingClient {
    
    func get(route: String) -> AnyPublisher<Any, Error> {
        return get(route).toJSON()
    }

    func get<T: Decodable>(_ route: String) -> AnyPublisher<T, Error> {
        return get(route).toModel()
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


public extension Publisher {

    @discardableResult
    func then(_ closure: @escaping (Output) -> Void) -> Self {
        var cancellable: AnyCancellable?
        cancellable = self.sink(receiveCompletion: { completion in
            cancellable = nil
        }) { value in
            closure(value)
        }
        return self
    }
    
        @discardableResult
        func onError(_ closure: @escaping (Failure) -> Void) -> Self {
            var cancellable: AnyCancellable?
            cancellable = self.sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let e):
                    closure(e)
                case .finished:
                    let fin = ""
                }
                cancellable = nil
            }) { _ in
                
            }
            return self
        }
}


// Post cannot be codable from another file
// this is very well explained here :
// https://forums.swift.org/t/why-you-cant-make-someone-elses-class-decodable-a-long-winded-explanation-of-required-initializers/6437
// extension Post: Codable {}
// For this reason it is advised to use a wrapper. Aka using and intermediary model conforming to Codable
// for mapping the JSON and then mapping to your original model, thus leaving your model clean and
// untouched by any Json parsing details.

public protocol BackedByJSONModel {
    associatedtype JSONModel: Decodable
    static func fromJSONModel(jsonModel: JSONModel) -> Self
}

// Generics Magick <3
// If the model asked for is Backed by a JSONModel
// Apply conversion automatically.
public extension NetworkingClient {

    func get<T: BackedByJSONModel>(_ route: String) -> AnyPublisher<T, Error> {
        return get(route).decode(type: T.JSONModel.self, decoder: JSONDecoder())
            .map { T.fromJSONModel(jsonModel: $0) }
        .eraseToAnyPublisher()
    }
    
    func get<T: BackedByJSONModel>(_ route: String) -> AnyPublisher<[T], Error> {
        return get(route).decode(type: [T.JSONModel].self, decoder: JSONDecoder())
            .map { v in
                return v.map { T.fromJSONModel(jsonModel: $0) }
        }
        .eraseToAnyPublisher()
    }
}


//public extension NetworkingClient {
//
//    func get(route: String) -> AnyPublisher<Any, Error> {
//        return get(route).toJSON()
//    }
//    
//}
