//
//  DeleteRequestTests.swift
//  
//
//  Created by Sacha DSO on 12/04/2022.
//

import Testing
import Foundation
import Networking

@Suite(.serialized)
struct DeleteRequestTests {
    
    private let network = NetworkingClient(baseURL: "https://mocked.com")

    init() async {
        await network.sessionConfiguration.protocolClasses = [MockingURLProtocol.self]
    }
    
    @Test
    func DELETEVoidAsyncWorks() async throws {
        MockingURLProtocol.mockedResponse =
        """
        { "response": "OK" }
        """
        let _: Void = try await network.delete("/users")
        #expect(MockingURLProtocol.currentRequest?.httpMethod == "DELETE")
        #expect(MockingURLProtocol.currentRequest?.url?.absoluteString == "https://mocked.com/users")
    }
    
    @Test
    func DELETEDataAsyncWorks() async throws {
        MockingURLProtocol.mockedResponse =
        """
        { "response": "OK" }
        """
        let data: Data = try await network.delete("/users")
        #expect(MockingURLProtocol.currentRequest?.httpMethod == "DELETE")
        #expect(MockingURLProtocol.currentRequest?.url?.absoluteString == "https://mocked.com/users")
        #expect(data == MockingURLProtocol.mockedResponse.data(using: String.Encoding.utf8))
    }
    
    @Test
    func DELETEJSONAsyncWorks() async throws {
        MockingURLProtocol.mockedResponse =
        """
        {"response":"OK"}
        """
        let json: JSON = try await network.delete("/users")
        #expect(MockingURLProtocol.currentRequest?.httpMethod == "DELETE")
        #expect(MockingURLProtocol.currentRequest?.url?.absoluteString == "https://mocked.com/users")
        let data = try? JSONSerialization.data(withJSONObject: json.value, options: [])
        let expectedResponseData =
        """
        {"response":"OK"}
        """.data(using: String.Encoding.utf8)
        #expect(data == expectedResponseData)
    }

    @Test
    func DELETEDecodableAsyncWorks() async throws {
        MockingURLProtocol.mockedResponse =
        """
        {
            "firstname":"John",
            "lastname":"Doe",
        }
        """
        let userJSON: UserJSON = try await network.delete("/users/1")
        #expect(MockingURLProtocol.currentRequest?.httpMethod == "DELETE")
        #expect(MockingURLProtocol.currentRequest?.url?.absoluteString == "https://mocked.com/users/1")
        #expect(userJSON.firstname == "John")
        #expect(userJSON.lastname == "Doe")
    }
    
    @Test
    func DELETEArrayOfDecodableAsyncWorks() async throws {
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
        let users: [UserJSON] = try await network.delete("/users")
        #expect(MockingURLProtocol.currentRequest?.httpMethod == "DELETE")
        #expect(MockingURLProtocol.currentRequest?.url?.absoluteString == "https://mocked.com/users")
        #expect(users[0].firstname == "John")
        #expect(users[0].lastname == "Doe")
        #expect(users[1].firstname == "Jimmy")
        #expect(users[1].lastname == "Punchline")
    }
}
