//
//  PatchRequestTests.swift
//  
//
//  Created by Sacha DSO on 12/04/2022.
//

import Foundation
import Testing
import Networking

@Suite
struct PatchRequestTests {
    
    private let network = NetworkingClient(baseURL: "https://mocked.com")

    init() {
        network.sessionConfiguration.protocolClasses = [MockingURLProtocol.self]
    }


    @Test
    func PATCHVoidAsyncWorks() async throws {
        MockingURLProtocol.mockedResponse =
        """
        { "response": "OK" }
        """
        let _:Void = try await network.patch("/users")
        #expect(MockingURLProtocol.currentRequest?.httpMethod == "PATCH")
        #expect(MockingURLProtocol.currentRequest?.url?.absoluteString == "https://mocked.com/users")
    }
    
    @Test
    func PATCHDataAsyncWorks() async throws {
        MockingURLProtocol.mockedResponse =
        """
        { "response": "OK" }
        """
        let data: Data = try await network.patch("/users")
        #expect(MockingURLProtocol.currentRequest?.httpMethod == "PATCH")
        #expect(MockingURLProtocol.currentRequest?.url?.absoluteString == "https://mocked.com/users")
        #expect(data == MockingURLProtocol.mockedResponse.data(using: String.Encoding.utf8))
    }
    
    @Test
    func PATCHJSONAsyncWorks() async throws {
        MockingURLProtocol.mockedResponse =
        """
        {"response":"OK"}
        """
        let json: Any = try await network.patch("/users")
        #expect(MockingURLProtocol.currentRequest?.httpMethod == "PATCH")
        #expect(MockingURLProtocol.currentRequest?.url?.absoluteString == "https://mocked.com/users")
        let data =  try? JSONSerialization.data(withJSONObject: json, options: [])
        let expectedResponseData =
        """
        {"response":"OK"}
        """.data(using: String.Encoding.utf8)
        #expect(data == expectedResponseData)
    }
    
    @Test
    func PATCHDecodableAsyncWorks() async throws {
        MockingURLProtocol.mockedResponse =
        """
        {
            "firstname":"John",
            "lastname":"Doe",
        }
        """
        let user: UserJSON = try await network.patch("/users/1")
        #expect(MockingURLProtocol.currentRequest?.httpMethod == "PATCH")
        #expect(MockingURLProtocol.currentRequest?.url?.absoluteString == "https://mocked.com/users/1")
        #expect(user.firstname == "John")
        #expect(user.lastname == "Doe")
    }

    @Test
    func PATCHArrayOfDecodableAsyncWorks() async throws {
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
        let users: [UserJSON] = try await network.patch("/users")
        #expect(MockingURLProtocol.currentRequest?.httpMethod == "PATCH")
        #expect(MockingURLProtocol.currentRequest?.url?.absoluteString == "https://mocked.com/users")
        #expect(users[0].firstname == "John")
        #expect(users[0].lastname == "Doe")
        #expect(users[1].firstname == "Jimmy")
        #expect(users[1].lastname == "Punchline")
    }
}
