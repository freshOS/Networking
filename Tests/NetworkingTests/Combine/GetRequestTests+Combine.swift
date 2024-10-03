//
//  GetRequestTests.swift
//  
//
//  Created by Sacha DSO on 12/04/2022.
//

import Testing
import Foundation
import Combine

@testable
import Networking

@Suite(.serialized)
class GetRequestCombineTests {
    
    private let network = NetworkingClient(baseURL: "https://mocked.com")
    private var cancellables = Set<AnyCancellable>()

    init() {
        network.sessionConfiguration.protocolClasses = [MockingURLProtocol.self]
    }

    @Test
    func GETVoidPublisher() async {
        MockingURLProtocol.mockedResponse =
        """
        { "response": "OK" }
        """
        
        let result = await withCheckedContinuation { continuation in
            network.get("/users").sink { completion in
                switch completion {
                case .failure(_):
                    Issue.record("Call failed")
                case .finished:
                    continuation.resume(returning: "done")
                }
            } receiveValue: { () in
                
            }
            .store(in: &cancellables)
        }
        #expect(result == "done")
        #expect(MockingURLProtocol.currentRequest?.httpMethod == "GET")
        #expect(MockingURLProtocol.currentRequest?.url?.absoluteString == "https://mocked.com/users")
        
    }
    
    @Test
    func GETDataPublisher() async {
        MockingURLProtocol.mockedResponse =
        """
        { "response": "OK" }
        """
        let result = await withCheckedContinuation { continuation in
            network.get("/users").sink { completion in
                switch completion {
                case .failure:
                    Issue.record("failure")
                case .finished:
                    print("finished")
                }
            } receiveValue: { (data: Data) in
                continuation.resume(returning: data)
            }
            .store(in: &cancellables)
        }
        #expect(MockingURLProtocol.currentRequest?.httpMethod == "GET")
        #expect(MockingURLProtocol.currentRequest?.url?.absoluteString == "https://mocked.com/users")
        #expect(result == MockingURLProtocol.mockedResponse.data(using: String.Encoding.utf8))
        
    }
    
    func foo() -> AnyPublisher<Sendable, Error> {
        return network.get("/users")
    }
    
    @Test
    func GETJSONPublisher() async {
        MockingURLProtocol.mockedResponse =
        """
        {"response":"OK"}
        """

        let result = await withCheckedContinuation { continuation in
            network.get("/users").sink { completion in
                switch completion {
                case .failure:
                    Issue.record("failure")
                case .finished:
                    print("finished")
                }
            } receiveValue: { (json: Sendable) in
                continuation.resume(returning: json)
            }
            .store(in: &cancellables)
        }
        
        #expect(MockingURLProtocol.currentRequest?.httpMethod == "GET")
        #expect(MockingURLProtocol.currentRequest?.url?.absoluteString == "https://mocked.com/users")
        let data = try? JSONSerialization.data(withJSONObject: result, options: [])
        let expectedResponseData =
        """
        {"response":"OK"}
        """.data(using: String.Encoding.utf8)
        
        #expect(data == expectedResponseData)
    }
//
//    func testGETNetworkingJSONDecodableWorks() {
//        MockingURLProtocol.mockedResponse =
//        """
//        {
//            "title":"Hello",
//            "content":"World",
//        }
//        """
//        let expectationWorks = expectation(description: "ReceiveValue called")
//        let expectationFinished = expectation(description: "Finished called")
//        network.get("/posts/1")
//            .sink { completion in
//            switch completion {
//            case .failure:
//                XCTFail()
//            case .finished:
//                XCTAssertEqual(MockingURLProtocol.currentRequest?.httpMethod, "GET")
//                XCTAssertEqual(MockingURLProtocol.currentRequest?.url?.absoluteString, "https://mocked.com/posts/1")
//                expectationFinished.fulfill()
//            }
//        } receiveValue: { (post: Post) in
//            XCTAssertEqual(post.title, "Hello")
//            XCTAssertEqual(post.content, "World")
//            expectationWorks.fulfill()
//        }
//        .store(in: &cancellables)
//        waitForExpectations(timeout: 0.1)
//    }
    
//    func testGETDecodableWorks() {
//        MockingURLProtocol.mockedResponse =
//        """
//        {
//            "firstname":"John",
//            "lastname":"Doe",
//        }
//        """
//        let expectationWorks = expectation(description: "ReceiveValue called")
//        let expectationFinished = expectation(description: "Finished called")
//        network.get("/users/1")
//            .sink { completion in
//            switch completion {
//            case .failure:
//                XCTFail()
//            case .finished:
//                XCTAssertEqual(MockingURLProtocol.currentRequest?.httpMethod, "GET")
//                XCTAssertEqual(MockingURLProtocol.currentRequest?.url?.absoluteString, "https://mocked.com/users/1")
//                expectationFinished.fulfill()
//            }
//        } receiveValue: { (userJSON: UserJSON) in
//            XCTAssertEqual(userJSON.firstname, "John")
//            XCTAssertEqual(userJSON.lastname, "Doe")
//            expectationWorks.fulfill()
//        }
//        .store(in: &cancellables)
//        waitForExpectations(timeout: 0.1)
//    }
//    func testGETArrayOfDecodableWorks() {
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
//        let expectationWorks = expectation(description: "ReceiveValue called")
//        let expectationFinished = expectation(description: "Finished called")
//        network.get("/users")
//            .sink { completion in
//            switch completion {
//            case .failure:
//                XCTFail()
//            case .finished:
//                XCTAssertEqual(MockingURLProtocol.currentRequest?.httpMethod, "GET")
//                XCTAssertEqual(MockingURLProtocol.currentRequest?.url?.absoluteString, "https://mocked.com/users")
//                expectationFinished.fulfill()
//            }
//        } receiveValue: { (userJSON: [UserJSON]) in
//            XCTAssertEqual(userJSON[0].firstname, "John")
//            XCTAssertEqual(userJSON[0].lastname, "Doe")
//            XCTAssertEqual(userJSON[1].firstname, "Jimmy")
//            XCTAssertEqual(userJSON[1].lastname, "Punchline")
//            expectationWorks.fulfill()
//        }
//        .store(in: &cancellables)
//        waitForExpectations(timeout: 0.1)
//    }
//
//    
//    
//    func testGETArrayOfDecodableWithKeypathWorks() {
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
//        let expectationWorks = expectation(description: "ReceiveValue called")
//        let expectationFinished = expectation(description: "Finished called")
//        network.get("/users", keypath: "users")
//            .sink { completion in
//            switch completion {
//            case .failure:
//                XCTFail()
//            case .finished:
//                XCTAssertEqual(MockingURLProtocol.currentRequest?.httpMethod, "GET")
//                XCTAssertEqual(MockingURLProtocol.currentRequest?.url?.absoluteString, "https://mocked.com/users")
//                expectationFinished.fulfill()
//            }
//        } receiveValue: { (userJSON: [UserJSON]) in
//            XCTAssertEqual(userJSON[0].firstname, "John")
//            XCTAssertEqual(userJSON[0].lastname, "Doe")
//            XCTAssertEqual(userJSON[1].firstname, "Jimmy")
//            XCTAssertEqual(userJSON[1].lastname, "Punchline")
//            expectationWorks.fulfill()
//        }
//        .store(in: &cancellables)
//        waitForExpectations(timeout: 0.1)
//    }
}

