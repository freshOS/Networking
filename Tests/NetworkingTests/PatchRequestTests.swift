//
//  PatchRequestTests.swift
//  
//
//  Created by Sacha DSO on 12/04/2022.
//

import Foundation
import XCTest
import Networking

class PatchRequestTests: XCTestCase {
    
    private let network = NetworkingClient(baseURL: "https://mocked.com")

    override func setUpWithError() throws {
        network.sessionConfiguration.protocolClasses = [MockingURLProtocol.self]
    }
    
    override func tearDownWithError() throws {
        MockingURLProtocol.mockedResponse = ""
        MockingURLProtocol.currentRequest = nil
    }

    func testPATCHVoidAsyncWorks() async throws {
        MockingURLProtocol.mockedResponse =
        """
        { "response": "OK" }
        """
        let _:Void = try await network.patch("/users")
        XCTAssertEqual(MockingURLProtocol.currentRequest?.httpMethod, "PATCH")
        XCTAssertEqual(MockingURLProtocol.currentRequest?.url?.absoluteString, "https://mocked.com/users")
    }
    
    func testPATCHDataAsyncWorks() async throws {
        MockingURLProtocol.mockedResponse =
        """
        { "response": "OK" }
        """
        let data: Data = try await network.patch("/users")
        XCTAssertEqual(MockingURLProtocol.currentRequest?.httpMethod, "PATCH")
        XCTAssertEqual(MockingURLProtocol.currentRequest?.url?.absoluteString, "https://mocked.com/users")
        XCTAssertEqual(data, MockingURLProtocol.mockedResponse.data(using: String.Encoding.utf8))
    }
    
    func testPATCHJSONAsyncWorks() async throws {
        MockingURLProtocol.mockedResponse =
        """
        {"response":"OK"}
        """
        let json: Any = try await network.patch("/users")
        XCTAssertEqual(MockingURLProtocol.currentRequest?.httpMethod, "PATCH")
        XCTAssertEqual(MockingURLProtocol.currentRequest?.url?.absoluteString, "https://mocked.com/users")
        let data =  try? JSONSerialization.data(withJSONObject: json, options: [])
        let expectedResponseData =
        """
        {"response":"OK"}
        """.data(using: String.Encoding.utf8)
        XCTAssertEqual(data, expectedResponseData)
    }
    
    func testPATCHDecodableAsyncWorks() async throws {
        MockingURLProtocol.mockedResponse =
        """
        {
            "firstname":"John",
            "lastname":"Doe",
        }
        """
        let user: UserJSON = try await network.patch("/users/1")
        XCTAssertEqual(MockingURLProtocol.currentRequest?.httpMethod, "PATCH")
        XCTAssertEqual(MockingURLProtocol.currentRequest?.url?.absoluteString, "https://mocked.com/users/1")
        XCTAssertEqual(user.firstname, "John")
        XCTAssertEqual(user.lastname, "Doe")
    }

    func testPATCHArrayOfDecodableAsyncWorks() async throws {
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
        XCTAssertEqual(MockingURLProtocol.currentRequest?.httpMethod, "PATCH")
        XCTAssertEqual(MockingURLProtocol.currentRequest?.url?.absoluteString, "https://mocked.com/users")
        XCTAssertEqual(users[0].firstname, "John")
        XCTAssertEqual(users[0].lastname, "Doe")
        XCTAssertEqual(users[1].firstname, "Jimmy")
        XCTAssertEqual(users[1].lastname, "Punchline")
    }
}
