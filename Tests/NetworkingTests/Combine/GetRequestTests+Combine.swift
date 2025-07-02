////
////  GetRequestTests.swift
////  
////
////  Created by Sacha DSO on 12/04/2022.
////
//
//import Testing
//import Foundation
//import Combine
//
//@testable
//import Networking
//
//@Suite(.serialized)
//class GetRequestCombineTests {
//    
//    private let network = NetworkingClient(baseURL: "https://mocked.com")
//    private var cancellables = Set<AnyCancellable>()
//
//    init() {
//        network.sessionConfiguration.protocolClasses = [MockingURLProtocol.self]
//    }
//
//    @Test
//    func GETVoidPublisher() async {
//        MockingURLProtocol.mockedResponse =
//        """
//        { "response": "OK" }
//        """
//        
//        let result = await withCheckedContinuation { continuation in
//            network.get("/users").sink { completion in
//                switch completion {
//                case .failure(_):
//                    Issue.record("Call failed")
//                case .finished:
//                    continuation.resume(returning: "done")
//                }
//            } receiveValue: { () in
//                
//            }
//            .store(in: &cancellables)
//        }
//        #expect(result == "done")
//        #expect(MockingURLProtocol.currentRequest?.httpMethod == "GET")
//        #expect(MockingURLProtocol.currentRequest?.url?.absoluteString == "https://mocked.com/users")
//        
//    }
//    
//    @Test
//    func GETDataPublisher() async {
//        MockingURLProtocol.mockedResponse =
//        """
//        { "response": "OK" }
//        """
//        let result = await withCheckedContinuation { continuation in
//            network.get("/users").sink { completion in
//                switch completion {
//                case .failure:
//                    Issue.record("failure")
//                case .finished:
//                    print("finished")
//                }
//            } receiveValue: { (data: Data) in
//                continuation.resume(returning: data)
//            }
//            .store(in: &cancellables)
//        }
//        #expect(MockingURLProtocol.currentRequest?.httpMethod == "GET")
//        #expect(MockingURLProtocol.currentRequest?.url?.absoluteString == "https://mocked.com/users")
//        #expect(result == MockingURLProtocol.mockedResponse.data(using: String.Encoding.utf8))
//        
//    }
//    
//    func foo() -> AnyPublisher<Sendable, Error> {
//        return network.get("/users")
//    }
//    
//    @Test
//    func GETJSONPublisher() async {
//        MockingURLProtocol.mockedResponse =
//        """
//        {"response":"OK"}
//        """
//
//        let result = await withCheckedContinuation { continuation in
//            network.get("/users").sink { completion in
//                switch completion {
//                case .failure:
//                    Issue.record("failure")
//                case .finished:
//                    print("finished")
//                }
//            } receiveValue: { (json: Sendable) in
//                continuation.resume(returning: json)
//            }
//            .store(in: &cancellables)
//        }
//        
//        #expect(MockingURLProtocol.currentRequest?.httpMethod == "GET")
//        #expect(MockingURLProtocol.currentRequest?.url?.absoluteString == "https://mocked.com/users")
//        let data = try? JSONSerialization.data(withJSONObject: result, options: [])
//        let expectedResponseData =
//        """
//        {"response":"OK"}
//        """.data(using: String.Encoding.utf8)
//        
//        #expect(data == expectedResponseData)
//    }
//
//    @Test
//    func GETNetworkingJSONDecodableWorks() async {
//        MockingURLProtocol.mockedResponse =
//        """
//        {
//            "title":"Hello",
//            "content":"World",
//        }
//        """
//        let post = await withCheckedContinuation { continuation in
//            network.get("/posts/1")
//                .sink { completion in
//                    switch completion {
//                    case .failure:
//                        Issue.record("failure")
//                    case .finished:
//                        print("finished")
//                    }
//                } receiveValue: { (post: Post) in
//                    continuation.resume(returning: post)
//                }
//                .store(in: &cancellables)
//        }
//        #expect(post.title == "Hello")
//        #expect(post.content == "World")
//        #expect(MockingURLProtocol.currentRequest?.httpMethod == "GET")
//        #expect(MockingURLProtocol.currentRequest?.url?.absoluteString == "https://mocked.com/posts/1")
//    }
//    
//    @Test
//    func GETDecodableWorks() async {
//        MockingURLProtocol.mockedResponse =
//        """
//        {
//            "firstname":"John",
//            "lastname":"Doe",
//        }
//        """
//        let userJSON = await withCheckedContinuation { continuation in
//            network.get("/users/1")
//                .sink { completion in
//                    switch completion {
//                    case .failure:
//                        Issue.record("failure")
//                    case .finished:
//                        print("finished")
//                    }
//                } receiveValue: { (userJSON: UserJSON) in
//                    continuation.resume(returning: userJSON)
//                }
//                .store(in: &cancellables)
//        }
//        #expect(userJSON.firstname == "John")
//        #expect(userJSON.lastname == "Doe")
//        #expect(MockingURLProtocol.currentRequest?.httpMethod == "GET")
//        #expect(MockingURLProtocol.currentRequest?.url?.absoluteString == "https://mocked.com/users/1")
//    }
//    
//    @Test
//    func GETArrayOfDecodableWorks() async {
//        MockingURLProtocol.mockedResponse =
//        """
//        [
//            {
//                "firstname":"John",
//                "lastname":"Doe"
//            },
//            {
//                "firstname":"Jimmy",
//                "lastname":"Punchline"
//            }
//        ]
//        """
//        let userJSON = await withCheckedContinuation { continuation in
//            network.get("/users")
//                .sink { completion in
//                    switch completion {
//                    case .failure:
//                        Issue.record("failure")
//                    case .finished:
//                        print("finished")
//                    }
//                } receiveValue: { (userJSON: [UserJSON]) in
//                    continuation.resume(returning: userJSON)
//                }
//                .store(in: &cancellables)
//        }
//        #expect(userJSON[0].firstname == "John")
//        #expect(userJSON[0].lastname == "Doe")
//        #expect(userJSON[1].firstname == "Jimmy")
//        #expect(userJSON[1].lastname == "Punchline")
//        #expect(MockingURLProtocol.currentRequest?.httpMethod == "GET")
//        #expect(MockingURLProtocol.currentRequest?.url?.absoluteString == "https://mocked.com/users")
//        
//    }
//
//    @Test
//    func GETArrayOfDecodableWithKeypathWorks() async {
//        MockingURLProtocol.mockedResponse =
//        """
//        {
//        "users" :
//            [
//                {
//                    "firstname":"John",
//                    "lastname":"Doe"
//                },
//                {
//                    "firstname":"Jimmy",
//                    "lastname":"Punchline"
//                }
//            ]
//        }
//        """
//        let userJSON = await withCheckedContinuation { continuation in
//            network.get("/users", keypath: "users")
//                .sink { completion in
//                    switch completion {
//                    case .failure:
//                        Issue.record("failure")
//                    case .finished:
//                        print("finished")
//                    }
//                } receiveValue: { (userJSON: [UserJSON]) in
//                    continuation.resume(returning: userJSON)
//                }
//                .store(in: &cancellables)
//        }
//        #expect(userJSON[0].firstname == "John")
//        #expect(userJSON[0].lastname == "Doe")
//        #expect(userJSON[1].firstname == "Jimmy")
//        #expect(userJSON[1].lastname == "Punchline")
//        #expect(MockingURLProtocol.currentRequest?.httpMethod == "GET")
//        #expect(MockingURLProtocol.currentRequest?.url?.absoluteString == "https://mocked.com/users")
//    }
//}
//
