////
////  PostRequestTests.swift
////  
////
////  Created by Sacha DSO on 12/04/2022.
////
//
//import Foundation
//import Testing
//import Combine
//
//@testable
//import Networking
//
//@Suite(.serialized)
//class PostRequestCombineTests  {
//    
//    private let network = NetworkingClient(baseURL: "https://mocked.com")
//    private var cancellables = Set<AnyCancellable>()
//
//    init() {
//        network.sessionConfiguration.protocolClasses = [MockingURLProtocol.self]
//    }
//    
//    @Test
//    func POSTVoidWorks() async {
//        MockingURLProtocol.mockedResponse =
//        """
//        { "response": "OK" }
//        """
//        let _: Void = await testHelper(network.post("/users"))
//        #expect(MockingURLProtocol.currentRequest?.httpMethod == "POST")
//        #expect(MockingURLProtocol.currentRequest?.url?.absoluteString == "https://mocked.com/users")
//    }
//    
//    @Test
//    func POSTDataWorks() async {
//        MockingURLProtocol.mockedResponse =
//        """
//        { "response": "OK" }
//        """
//        let data: Data = await testHelper(network.post("/users"))
//        #expect(MockingURLProtocol.currentRequest?.httpMethod == "POST")
//        #expect(MockingURLProtocol.currentRequest?.url?.absoluteString == "https://mocked.com/users")
//        #expect(data == MockingURLProtocol.mockedResponse.data(using: String.Encoding.utf8))
//    }
//    
//    @Test
//    func POSTJSONWorks() async {
//        MockingURLProtocol.mockedResponse =
//        """
//        {"response":"OK"}
//        """
//        let json: JSON = await testHelper(network.post("/users"))
//        #expect(MockingURLProtocol.currentRequest?.httpMethod == "POST")
//        #expect(MockingURLProtocol.currentRequest?.url?.absoluteString == "https://mocked.com/users")
//        let data =  try? JSONSerialization.data(withJSONObject: json.value, options: [])
//        let expectedResponseData =
//        """
//        {"response":"OK"}
//        """.data(using: String.Encoding.utf8)
//        #expect(data == expectedResponseData)
//    }
//    
//    @Test
//    func POSTNetworkingJSONDecodableWorks() async {
//        MockingURLProtocol.mockedResponse =
//        """
//        {
//            "title":"Hello",
//            "content":"World",
//        }
//        """
//        let post: Post = await testHelper(network.post("/posts/1"))
//        #expect(MockingURLProtocol.currentRequest?.httpMethod == "POST")
//        #expect(MockingURLProtocol.currentRequest?.url?.absoluteString == "https://mocked.com/posts/1")
//        #expect(post.title == "Hello")
//        #expect(post.content == "World")
//    }
//    
//    @Test
//    func POSTDecodableWorks() async {
//        MockingURLProtocol.mockedResponse =
//        """
//        {
//            "firstname":"John",
//            "lastname":"Doe",
//        }
//        """
//        let userJSON: UserJSON = await testHelper(network.post("/users/1"))
//        #expect(MockingURLProtocol.currentRequest?.httpMethod == "POST")
//        #expect(MockingURLProtocol.currentRequest?.url?.absoluteString == "https://mocked.com/users/1")
//        #expect(userJSON.firstname == "John")
//        #expect(userJSON.lastname == "Doe")
//    }
//    
//    @Test
//    func POSTArrayOfDecodableWorks() async {
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
//        let userJSON: [UserJSON] = await testHelper(network.post("/users"))
//        #expect(MockingURLProtocol.currentRequest?.httpMethod == "POST")
//        #expect(MockingURLProtocol.currentRequest?.url?.absoluteString == "https://mocked.com/users")
//        #expect(userJSON[0].firstname == "John")
//        #expect(userJSON[0].lastname == "Doe")
//        #expect(userJSON[1].firstname == "Jimmy")
//        #expect(userJSON[1].lastname == "Punchline")
//    }
//    
//    @Test
//    func POSTArrayOfDecodableWithKeypathWorks() async {
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
//        let userJSON: [UserJSON] = await testHelper(network.post("/users", keypath: "users"))
//        #expect(MockingURLProtocol.currentRequest?.httpMethod == "POST")
//        #expect(MockingURLProtocol.currentRequest?.url?.absoluteString == "https://mocked.com/users")
//        #expect(userJSON[0].firstname == "John")
//        #expect(userJSON[0].lastname == "Doe")
//        #expect(userJSON[1].firstname == "Jimmy")
//        #expect(userJSON[1].lastname == "Punchline")
//    }
//
//    @Test
//    func POSTDataEncodableWorks() async {
//        MockingURLProtocol.mockedResponse =
//        """
//        { "response": "OK" }
//        """
//        let creds = Credentials(username: "Alan", password: "Turing")
//        let data: Data = await testHelper(network.post("/users", body: creds))
//        #expect(MockingURLProtocol.currentRequest?.httpMethod == "POST")
//        #expect(MockingURLProtocol.currentRequest?.url?.absoluteString == "https://mocked.com/users")
//        let body = MockingURLProtocol.currentRequest?.httpBodyStreamAsDictionary()
//        #expect(body?["username"] as? String == "Alan")
//        #expect(body?["password"] as? String == "Turing")
//        #expect(data == MockingURLProtocol.mockedResponse.data(using: String.Encoding.utf8))
//    }
//    
//    func testHelper<T: Sendable>(_ publisher: AnyPublisher<T, Error>) async -> T {
//        return await withCheckedContinuation { continuation in
//            publisher.sink { completion in
//                switch completion {
//                case .failure(_):
//                    Issue.record("failure")
//                case .finished:
//                    print("finished")
//                }
//            } receiveValue: { x in
//                continuation.resume(returning: x)
//            }
//            .store(in: &cancellables)
//        }
//    }
//}
