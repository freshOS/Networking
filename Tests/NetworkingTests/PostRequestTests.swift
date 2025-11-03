//
//  PostRequestTests.swift
//  
//
//  Created by Sacha DSO on 12/04/2022.
//

import Foundation
import Testing
import Networking

@Suite
struct PostRequestTests {
    
    private let network = NetworkingClient(baseURL: "https://mocked.com")

    init() async {
        await network.sessionConfiguration.protocolClasses = [MockingURLProtocol.self]
    }
    
    @Test
    func testPOSTVoidAsyncWorks() async throws {
        MockingURLProtocol.mockedResponse =
        """
        { "response": "OK" }
        """
        let _: Void = try await network.post("/users")
        #expect(MockingURLProtocol.currentRequest?.httpMethod == "POST")
        #expect(MockingURLProtocol.currentRequest?.url?.absoluteString == "https://mocked.com/users")
    }
    
    @Test
    func testPOSTDataAsyncWorks() async throws {
        MockingURLProtocol.mockedResponse =
        """
        { "response": "OK" }
        """
        let data: Data = try await network.post("/users")
        #expect(MockingURLProtocol.currentRequest?.httpMethod == "POST")
        #expect(MockingURLProtocol.currentRequest?.url?.absoluteString == "https://mocked.com/users")
        #expect(data == MockingURLProtocol.mockedResponse.data(using: String.Encoding.utf8))
    }
    
    @Test
    func testPOSTJSONAsyncWorks() async throws {
        MockingURLProtocol.mockedResponse =
        """
        {"response":"OK"}
        """
        let json: JSON = try await network.post("/users")
        #expect(MockingURLProtocol.currentRequest?.httpMethod == "POST")
        #expect(MockingURLProtocol.currentRequest?.url?.absoluteString == "https://mocked.com/users")
        let data =  try? JSONSerialization.data(withJSONObject: json.value, options: [])
        let expectedResponseData =
        """
        {"response":"OK"}
        """.data(using: String.Encoding.utf8)
        #expect(data == expectedResponseData)
    }
    
    @Test
    func testPOSTDecodableAsyncWorks() async throws {
        MockingURLProtocol.mockedResponse =
        """
        {
            "firstname":"John",
            "lastname":"Doe",
        }
        """
        let userJSON:UserJSON = try await network.post("/users/1")
        #expect(MockingURLProtocol.currentRequest?.httpMethod == "POST")
        #expect(MockingURLProtocol.currentRequest?.url?.absoluteString == "https://mocked.com/users/1")
        #expect(userJSON.firstname == "John")
        #expect(userJSON.lastname == "Doe")
    }
    
    @Test
    func testPOSTArrayOfDecodableAsyncWorks() async throws {
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
        let users: [UserJSON] = try await network.post("/users")
        #expect(MockingURLProtocol.currentRequest?.httpMethod == "POST")
        #expect(MockingURLProtocol.currentRequest?.url?.absoluteString == "https://mocked.com/users")
        #expect(users[0].firstname == "John")
        #expect(users[0].lastname == "Doe")
        #expect(users[1].firstname == "Jimmy")
        #expect(users[1].lastname == "Punchline")
    }
    
    @Test
    func testAsyncPostEncodable() async throws {
        MockingURLProtocol.mockedResponse =
            """
            { "response": "OK" }
            """
        
        let creds = Credentials(username: "john", password: "doe")
        let data: Data = try await network.post("/users", body: creds)
        #expect(MockingURLProtocol.currentRequest?.httpMethod == "POST")
        #expect(MockingURLProtocol.currentRequest?.url?.absoluteString == "https://mocked.com/users")
        #expect(data == MockingURLProtocol.mockedResponse.data(using: String.Encoding.utf8))
        
        let body = MockingURLProtocol.currentRequest?.httpBodyStreamAsDictionary()
        #expect(body?["username"] as? String == "john")
        #expect(body?["password"] as? String == "doe")
    }
}

struct Credentials: Encodable {
    let username: String
    let password: String
}
