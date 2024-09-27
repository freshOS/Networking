//
//  PostRequestTests.swift
//  
//
//  Created by Sacha DSO on 12/04/2022.
//

import Foundation
import XCTest
import Networking


class PostRequestTests: XCTestCase {
    
    private let network = NetworkingClient(baseURL: "https://mocked.com")

    override func setUpWithError() throws {
        network.sessionConfiguration.protocolClasses = [MockingURLProtocol.self]
    }
    
    override func tearDownWithError() throws {
        MockingURLProtocol.mockedResponse = ""
        MockingURLProtocol.currentRequest = nil
    }
    
    func testPOSTVoidAsyncWorks() async throws {
        MockingURLProtocol.mockedResponse =
        """
        { "response": "OK" }
        """
        let _: Void = try await network.post("/users")
        XCTAssertEqual(MockingURLProtocol.currentRequest?.httpMethod, "POST")
        XCTAssertEqual(MockingURLProtocol.currentRequest?.url?.absoluteString, "https://mocked.com/users")
    }
    
    func testPOSTDataAsyncWorks() async throws {
        MockingURLProtocol.mockedResponse =
        """
        { "response": "OK" }
        """
        let data: Data = try await network.post("/users")
        XCTAssertEqual(MockingURLProtocol.currentRequest?.httpMethod, "POST")
        XCTAssertEqual(MockingURLProtocol.currentRequest?.url?.absoluteString, "https://mocked.com/users")
        XCTAssertEqual(data, MockingURLProtocol.mockedResponse.data(using: String.Encoding.utf8))
    }
    
    func testPOSTJSONAsyncWorks() async throws {
        MockingURLProtocol.mockedResponse =
        """
        {"response":"OK"}
        """
        let json: JSON = try await network.post("/users")
        XCTAssertEqual(MockingURLProtocol.currentRequest?.httpMethod, "POST")
        XCTAssertEqual(MockingURLProtocol.currentRequest?.url?.absoluteString, "https://mocked.com/users")
        let data =  try? JSONSerialization.data(withJSONObject: json.value, options: [])
        let expectedResponseData =
        """
        {"response":"OK"}
        """.data(using: String.Encoding.utf8)
        XCTAssertEqual(data, expectedResponseData)
    }
    
    func testPOSTDecodableAsyncWorks() async throws {
        MockingURLProtocol.mockedResponse =
        """
        {
            "firstname":"John",
            "lastname":"Doe",
        }
        """
        let userJSON:UserJSON = try await network.post("/users/1")
        XCTAssertEqual(MockingURLProtocol.currentRequest?.httpMethod, "POST")
        XCTAssertEqual(MockingURLProtocol.currentRequest?.url?.absoluteString, "https://mocked.com/users/1")
        XCTAssertEqual(userJSON.firstname, "John")
        XCTAssertEqual(userJSON.lastname, "Doe")
    }
    
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
        XCTAssertEqual(MockingURLProtocol.currentRequest?.httpMethod, "POST")
        XCTAssertEqual(MockingURLProtocol.currentRequest?.url?.absoluteString, "https://mocked.com/users")
        XCTAssertEqual(users[0].firstname, "John")
        XCTAssertEqual(users[0].lastname, "Doe")
        XCTAssertEqual(users[1].firstname, "Jimmy")
        XCTAssertEqual(users[1].lastname, "Punchline")
    }
    
    func testAsyncPostEncodable() async throws {
        MockingURLProtocol.mockedResponse =
            """
            { "response": "OK" }
            """
        
        let creds = Credentials(username: "john", password: "doe")
        let data: Data = try await network.post("/users", body: creds)
        XCTAssertEqual(MockingURLProtocol.currentRequest?.httpMethod, "POST")
        XCTAssertEqual(MockingURLProtocol.currentRequest?.url?.absoluteString, "https://mocked.com/users")
        XCTAssertEqual(data, MockingURLProtocol.mockedResponse.data(using: String.Encoding.utf8))
        
        let body = MockingURLProtocol.currentRequest?.httpBodyStreamAsDictionary()
        XCTAssertEqual(body?["username"] as? String, "john")
        XCTAssertEqual(body?["password"] as? String, "doe")
    }
}

struct Credentials: Encodable {
    let username: String
    let password: String
}
