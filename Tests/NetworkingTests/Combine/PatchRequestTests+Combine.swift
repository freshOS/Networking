//
//  PatchRequestTests.swift
//  
//
//  Created by Sacha DSO on 12/04/2022.
//

import Foundation
import Testing
import Combine

@testable
import Networking

@Suite(.serialized)
class PatchRequestCombineTests {
    
    private let network = NetworkingClient(baseURL: "https://mocked.com")
    private var cancellables = Set<AnyCancellable>()

    init() {
        network.sessionConfiguration.protocolClasses = [MockingURLProtocol.self]
    }
    
    @Test
    func PATCHVoidWorks() async {
        MockingURLProtocol.mockedResponse =
        """
        { "response": "OK" }
        """
        let _: Void = await testHelper(network.patch("/users"))
        #expect(MockingURLProtocol.currentRequest?.httpMethod == "PATCH")
        #expect(MockingURLProtocol.currentRequest?.url?.absoluteString == "https://mocked.com/users")
    }
    
    @Test
    func PATCHDataWorks() async {
        MockingURLProtocol.mockedResponse =
        """
        { "response": "OK" }
        """
        let data: Data = await testHelper(network.patch("/users"))
        #expect(MockingURLProtocol.currentRequest?.httpMethod == "PATCH")
        #expect(MockingURLProtocol.currentRequest?.url?.absoluteString == "https://mocked.com/users")
        #expect(data == MockingURLProtocol.mockedResponse.data(using: String.Encoding.utf8))
    }
    
    @Test
    func PATCHJSONWorks() async {
        MockingURLProtocol.mockedResponse =
        """
        {"response":"OK"}
        """
        let json: JSON = await testHelper(network.patch("/users"))
        #expect(MockingURLProtocol.currentRequest?.httpMethod == "PATCH")
        #expect(MockingURLProtocol.currentRequest?.url?.absoluteString == "https://mocked.com/users")
        let data =  try? JSONSerialization.data(withJSONObject: json.value, options: [])
        let expectedResponseData =
        """
        {"response":"OK"}
        """.data(using: String.Encoding.utf8)
        #expect(data == expectedResponseData)
    }
    
    @Test
    func testPATCHNetworkingJSONDecodableWorks() async {
        MockingURLProtocol.mockedResponse =
        """
        {
            "title":"Hello",
            "content":"World",
        }
        """
        let post: Post = await testHelper(network.patch("/posts/1"))
        #expect(MockingURLProtocol.currentRequest?.httpMethod == "PATCH")
        #expect(MockingURLProtocol.currentRequest?.url?.absoluteString == "https://mocked.com/posts/1")
        #expect(post.title == "Hello")
        #expect(post.content == "World")
    }
    
    @Test
    func PATCHDecodableWorks() async {
        MockingURLProtocol.mockedResponse =
        """
        {
            "firstname":"John",
            "lastname":"Doe",
        }
        """
        let userJSON: UserJSON = await testHelper(network.patch("/users/1"))
        #expect(MockingURLProtocol.currentRequest?.httpMethod == "PATCH")
        #expect(MockingURLProtocol.currentRequest?.url?.absoluteString == "https://mocked.com/users/1")
        #expect(userJSON.firstname == "John")
        #expect(userJSON.lastname == "Doe")
    }
    
    @Test
    func PATCHArrayOfDecodableWorks() async {
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
        let userJSON: [UserJSON] = await testHelper(network.patch("/users"))
        #expect(MockingURLProtocol.currentRequest?.httpMethod == "PATCH")
        #expect(MockingURLProtocol.currentRequest?.url?.absoluteString == "https://mocked.com/users")
        #expect(userJSON[0].firstname == "John")
        #expect(userJSON[0].lastname == "Doe")
        #expect(userJSON[1].firstname == "Jimmy")
        #expect(userJSON[1].lastname == "Punchline")
    }
    
    @Test
    func testPATCHArrayOfDecodableWithKeypathWorks() async {
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
        let userJSON: [UserJSON] = await testHelper(network.patch("/users", keypath: "users"))
        #expect(MockingURLProtocol.currentRequest?.httpMethod == "PATCH")
        #expect(MockingURLProtocol.currentRequest?.url?.absoluteString == "https://mocked.com/users")
        #expect(userJSON[0].firstname == "John")
        #expect(userJSON[0].lastname == "Doe")
        #expect(userJSON[1].firstname == "Jimmy")
        #expect(userJSON[1].lastname == "Punchline")
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
