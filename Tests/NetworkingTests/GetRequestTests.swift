//
//  GetRequestTests.swift
//  
//
//  Created by Sacha DSO on 12/04/2022.
//

import Testing
import Foundation
import Networking

@Suite(.serialized)
struct GetRequestTests {
    
    private let network = NetworkingClient(baseURL: "https://mocked.com")

    init() async {
        await network.sessionConfiguration.protocolClasses = [MockingURLProtocol.self]
    }
    
    @Test
    func GETVoidAsyncWorks() async throws {
        MockingURLProtocol.mockedResponse =
        """
        { "response": "OK" }
        """
        let _:Void = try await network.get("/users")
        #expect(MockingURLProtocol.currentRequest?.httpMethod == "GET")
        #expect(MockingURLProtocol.currentRequest?.url?.absoluteString == "https://mocked.com/users")
    }
    
    @Test
    func GETVoidAsyncWithURLParams() async throws {
        MockingURLProtocol.mockedResponse =
        """
        { "response": "OK" }
        """
        
        let _:Void = try await network.get("/users", params: ["search" : "lion"])
        #expect(MockingURLProtocol.currentRequest?.httpMethod == "GET")
        #expect(MockingURLProtocol.currentRequest?.url?.absoluteString == "https://mocked.com/users?search=lion")
    }

    @Test
    func GETDataAsyncWorks() async throws {
        MockingURLProtocol.mockedResponse =
        """
        { "response": "OK" }
        """
        let data: Data = try await network.get("/users")
        #expect(MockingURLProtocol.currentRequest?.httpMethod == "GET")
        #expect(MockingURLProtocol.currentRequest?.url?.absoluteString == "https://mocked.com/users")
        #expect(data == MockingURLProtocol.mockedResponse.data(using: String.Encoding.utf8))
    }
    
    @Test
    func GETJSONAsyncWorks() async throws {
        let mockedJson =
        """
        {"response":"OK"}
        """
        MockingURLProtocol.mockedResponse = mockedJson
        let json: JSON = try await network.get("/users")
        #expect(MockingURLProtocol.currentRequest?.httpMethod == "GET")
        #expect(MockingURLProtocol.currentRequest?.url?.absoluteString == "https://mocked.com/users")
        
        let expectedResponseData = mockedJson.data(using: String.Encoding.utf8)
        let data = try? JSONSerialization.data(withJSONObject: json.value, options: [])
        #expect(data == expectedResponseData)
    }
    
    @Test
    func GETNetworkingJSONDecodableAsyncWorks() async throws {
        MockingURLProtocol.mockedResponse =
        """
        {
            "firstname":"John",
            "lastname":"Doe",
        }
        """
        let userJSON: UserJSON = try await network.get("/posts/1")
        #expect(MockingURLProtocol.currentRequest?.httpMethod == "GET")
        #expect(MockingURLProtocol.currentRequest?.url?.absoluteString == "https://mocked.com/posts/1")
        #expect(userJSON.firstname == "John")
        #expect(userJSON.lastname == "Doe")
    }
    
    @Test
    func GETArrayOfDecodableAsyncWorks() async throws {
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
        let users: [UserJSON] = try await network.get("/users")
        #expect(MockingURLProtocol.currentRequest?.httpMethod == "GET")
        #expect(MockingURLProtocol.currentRequest?.url?.absoluteString == "https://mocked.com/users")
        #expect(users[0].firstname == "John")
        #expect(users[0].lastname == "Doe")
        #expect(users[1].firstname == "Jimmy")
        #expect(users[1].lastname == "Punchline")
    }
}

