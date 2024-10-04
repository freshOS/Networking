//
//  DeleteRequestTests.swift
//  
//
//  Created by Sacha DSO on 12/04/2022.
//

import Testing
import Combine
import Foundation
import Networking

@Suite(.serialized)
class DeleteRequestCombineTests {
    
    private let network = NetworkingClient(baseURL: "https://mocked.com")
    private var cancellables = Set<AnyCancellable>()

    init() {
        network.sessionConfiguration.protocolClasses = [MockingURLProtocol.self]
    }

    @Test
    func DELETEVoidWorks() async {
        MockingURLProtocol.mockedResponse =
        """
        { "response": "OK" }
        """
        
        let void: Void = await testHelper(network.delete("/users"))
        #expect(MockingURLProtocol.currentRequest?.httpMethod == "DELETE")
        #expect(MockingURLProtocol.currentRequest?.url?.absoluteString == "https://mocked.com/users")
    }

    @Test
    func DELETEDataWorks() async {
        MockingURLProtocol.mockedResponse =
        """
        { "response": "OK" }
        """
        let data: Data = await testHelper(network.delete("/users"))
        #expect(data != nil)
        #expect(MockingURLProtocol.currentRequest?.httpMethod == "DELETE")
        #expect(MockingURLProtocol.currentRequest?.url?.absoluteString == "https://mocked.com/users")
    }
    
    @Test
    func DELETEJSONWorks() async {
        MockingURLProtocol.mockedResponse =
        """
        {"response":"OK"}
        """
        let json: JSON = await testHelper(network.delete("/users"))
        #expect(MockingURLProtocol.currentRequest?.httpMethod == "DELETE")
        #expect(MockingURLProtocol.currentRequest?.url?.absoluteString == "https://mocked.com/users")
        let data =  try? JSONSerialization.data(withJSONObject: json.value, options: [])
        let expectedResponseData =
        """
        {"response":"OK"}
        """.data(using: String.Encoding.utf8)
        #expect(data == expectedResponseData)
    }
    // Todo put back Sendable version
    
    @Test
    func testDELETENetworkingJSONDecodableWorks() async {
        MockingURLProtocol.mockedResponse =
        """
        {
            "title":"Hello",
            "content":"World",
        }
        """
        let post: Post = await testHelper(network.delete("/posts/1"))
        #expect(post.title == "Hello")
        #expect(post.content == "World")
        #expect(MockingURLProtocol.currentRequest?.httpMethod == "DELETE")
        #expect(MockingURLProtocol.currentRequest?.url?.absoluteString == "https://mocked.com/posts/1")
    }
    
    @Test
    func testDELETEDecodableWorks() async {
        MockingURLProtocol.mockedResponse =
        """
        {
            "firstname":"John",
            "lastname":"Doe",
        }
        """
        let userJSON: UserJSON = await testHelper(network.delete("/users/1"))
        #expect(userJSON.firstname == "John")
        #expect(userJSON.lastname == "Doe")
        #expect(MockingURLProtocol.currentRequest?.httpMethod == "DELETE")
        #expect(MockingURLProtocol.currentRequest?.url?.absoluteString == "https://mocked.com/users/1")
    }

    @Test
    func testDELETEArrayOfDecodableWorks() async {
        MockingURLProtocol.mockedResponse =
        """
        [
            {
                "firstname":"John",
                "lastname":"Doe"
            },
            {
                "firstname":"Jimmy",
                "lastname":"Punchline"
            }
        ]
        """
        let userJSON: [UserJSON] = await testHelper(network.delete("/users"))
        #expect(userJSON[0].firstname == "John")
        #expect(userJSON[0].lastname == "Doe")
        #expect(userJSON[1].firstname == "Jimmy")
        #expect(userJSON[1].lastname == "Punchline")
        #expect(MockingURLProtocol.currentRequest?.httpMethod == "DELETE")
        #expect(MockingURLProtocol.currentRequest?.url?.absoluteString == "https://mocked.com/users")
    }

    @Test
    func testDELETEArrayOfDecodableWithKeypathWorks() async {
        MockingURLProtocol.mockedResponse =
        """
        {
        "users" :
            [
                {
                    "firstname":"John",
                    "lastname":"Doe"
                },
                {
                    "firstname":"Jimmy",
                    "lastname":"Punchline"
                }
            ]
        }
        """
        let userJSON: [UserJSON] = await testHelper(network.delete("/users", keypath: "users"))
        #expect(userJSON[0].firstname == "John")
        #expect(userJSON[0].lastname == "Doe")
        #expect(userJSON[1].firstname == "Jimmy")
        #expect(userJSON[1].lastname == "Punchline")
        #expect(MockingURLProtocol.currentRequest?.httpMethod == "DELETE")
        #expect(MockingURLProtocol.currentRequest?.url?.absoluteString == "https://mocked.com/users")
    }
    
    func testHelper<T: Sendable>(_ publisher: AnyPublisher<T, Error>) async -> T {
        return await withCheckedContinuation { continuation in
            publisher.sink { completion in
                switch completion {
                case .failure(_):
                    Issue.record("failure")
                case .finished:
                    print("finished")
                }
            } receiveValue: { x in
                continuation.resume(returning: x)
            }
            .store(in: &cancellables)
        }
    }
}
