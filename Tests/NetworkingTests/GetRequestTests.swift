//
//  GetRequestTests.swift
//  
//
//  Created by Sacha DSO on 12/04/2022.
//

import Foundation
import XCTest
import Combine

@testable
import Networking

final class GetRequestTests: XCTestCase {
    
    private let network = NetworkingClient(baseURL: "https://mocked.com")
    private var cancellables = Set<AnyCancellable>()

    override func setUpWithError() throws {
        network.sessionConfiguration.protocolClasses = [MockingURLProtocol.self]
    }
    
    override func tearDownWithError() throws {
        MockingURLProtocol.mockedResponse = ""
        MockingURLProtocol.currentRequest = nil
    }
    
    func testGETVoidWorks() {
        MockingURLProtocol.mockedResponse =
        """
        { "response": "OK" }
        """
        let expectationWorks = expectation(description: "Call works")
        let expectationFinished = expectation(description: "Finished")
        network.get("/users").sink { completion in
            switch completion {
            case .failure(_):
                XCTFail()
            case .finished:
                expectationFinished.fulfill()
            }
        } receiveValue: { () in
            expectationWorks.fulfill()
        }
        .store(in: &cancellables)
        waitForExpectations(timeout: 0.1)
    }
    
    func testGETDataWorks() {
        MockingURLProtocol.mockedResponse =
        """
        { "response": "OK" }
        """
        let expectationWorks = expectation(description: "ReceiveValue called")
        let expectationFinished = expectation(description: "Finished called")
        network.get("/users").sink { completion in
            switch completion {
            case .failure:
                XCTFail()
            case .finished:
                XCTAssertEqual(MockingURLProtocol.currentRequest?.httpMethod, "GET")
                XCTAssertEqual(MockingURLProtocol.currentRequest?.url?.absoluteString, "https://mocked.com/users")
                expectationFinished.fulfill()
                
            }
        } receiveValue: { (data: Data) in
            XCTAssertEqual(data, MockingURLProtocol.mockedResponse.data(using: String.Encoding.utf8))
            expectationWorks.fulfill()
        }
        .store(in: &cancellables)
        waitForExpectations(timeout: 0.1)
    }
    
    func testGETJSONWorks() {
        MockingURLProtocol.mockedResponse =
        """
        {"response":"OK"}
        """
        let expectationWorks = expectation(description: "ReceiveValue called")
        let expectationFinished = expectation(description: "Finished called")
        network.get("/users").sink { completion in
            switch completion {
            case .failure:
                XCTFail()
            case .finished:
                XCTAssertEqual(MockingURLProtocol.currentRequest?.httpMethod, "GET")
                XCTAssertEqual(MockingURLProtocol.currentRequest?.url?.absoluteString, "https://mocked.com/users")
                expectationFinished.fulfill()
            }
        } receiveValue: { (json: Any) in
            let data =  try? JSONSerialization.data(withJSONObject: json, options: [])
            let expectedResponseData =
            """
            {"response":"OK"}
            """.data(using: String.Encoding.utf8)

            XCTAssertEqual(data, expectedResponseData)
            expectationWorks.fulfill()
        }
        .store(in: &cancellables)
        waitForExpectations(timeout: 0.1)
    }
    
    func testGETNetworkingJSONDecodableWorks() {
        MockingURLProtocol.mockedResponse =
        """
        {
            "title":"Hello",
            "content":"World",
        }
        """
        let expectationWorks = expectation(description: "ReceiveValue called")
        let expectationFinished = expectation(description: "Finished called")
        network.get("/posts/1")
            .sink { completion in
            switch completion {
            case .failure:
                XCTFail()
            case .finished:
                XCTAssertEqual(MockingURLProtocol.currentRequest?.httpMethod, "GET")
                XCTAssertEqual(MockingURLProtocol.currentRequest?.url?.absoluteString, "https://mocked.com/posts/1")
                expectationFinished.fulfill()
            }
        } receiveValue: { (post: Post) in
            XCTAssertEqual(post.title, "Hello")
            XCTAssertEqual(post.content, "World")
            expectationWorks.fulfill()
        }
        .store(in: &cancellables)
        waitForExpectations(timeout: 0.1)
    }
    
    func testGETDecodableWorks() {
        MockingURLProtocol.mockedResponse =
        """
        {
            "firstname":"John",
            "lastname":"Doe",
        }
        """
        let expectationWorks = expectation(description: "ReceiveValue called")
        let expectationFinished = expectation(description: "Finished called")
        network.get("/users/1")
            .sink { completion in
            switch completion {
            case .failure:
                XCTFail()
            case .finished:
                XCTAssertEqual(MockingURLProtocol.currentRequest?.httpMethod, "GET")
                XCTAssertEqual(MockingURLProtocol.currentRequest?.url?.absoluteString, "https://mocked.com/users/1")
                expectationFinished.fulfill()
            }
        } receiveValue: { (userJSON: UserJSON) in
            XCTAssertEqual(userJSON.firstname, "John")
            XCTAssertEqual(userJSON.lastname, "Doe")
            expectationWorks.fulfill()
        }
        .store(in: &cancellables)
        waitForExpectations(timeout: 0.1)
    }
    
    func testGETArrayOfDecodableWorks() {
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
        let expectationWorks = expectation(description: "ReceiveValue called")
        let expectationFinished = expectation(description: "Finished called")
        network.get("/users")
            .sink { completion in
            switch completion {
            case .failure:
                XCTFail()
            case .finished:
                XCTAssertEqual(MockingURLProtocol.currentRequest?.httpMethod, "GET")
                XCTAssertEqual(MockingURLProtocol.currentRequest?.url?.absoluteString, "https://mocked.com/users")
                expectationFinished.fulfill()
            }
        } receiveValue: { (userJSON: [UserJSON]) in
            XCTAssertEqual(userJSON[0].firstname, "John")
            XCTAssertEqual(userJSON[0].lastname, "Doe")
            XCTAssertEqual(userJSON[1].firstname, "Jimmy")
            XCTAssertEqual(userJSON[1].lastname, "Punchline")
            expectationWorks.fulfill()
        }
        .store(in: &cancellables)
        waitForExpectations(timeout: 0.1)
    }
    
    func testGETArrayOfDecodableWithKeypathWorks() {
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
        let expectationWorks = expectation(description: "ReceiveValue called")
        let expectationFinished = expectation(description: "Finished called")
        network.get("/users", keypath: "users")
            .sink { completion in
            switch completion {
            case .failure:
                XCTFail()
            case .finished:
                XCTAssertEqual(MockingURLProtocol.currentRequest?.httpMethod, "GET")
                XCTAssertEqual(MockingURLProtocol.currentRequest?.url?.absoluteString, "https://mocked.com/users")
                expectationFinished.fulfill()
            }
        } receiveValue: { (userJSON: [UserJSON]) in
            XCTAssertEqual(userJSON[0].firstname, "John")
            XCTAssertEqual(userJSON[0].lastname, "Doe")
            XCTAssertEqual(userJSON[1].firstname, "Jimmy")
            XCTAssertEqual(userJSON[1].lastname, "Punchline")
            expectationWorks.fulfill()
        }
        .store(in: &cancellables)
        waitForExpectations(timeout: 0.1)
    }
}

