//
//  PutRequestTests.swift
//
//
//  Created by Sacha DSO on 12/04/2022.
//

import Foundation
import Testing
import Combine

@testable
import Networking

@Suite
struct PutRequestCombineTests {
    
    private let network = NetworkingClient(baseURL: "https://mocked.com")
    private var cancellables = Set<AnyCancellable>()

    init() {
        network.sessionConfiguration.protocolClasses = [MockingURLProtocol.self]
    }
    

//    func testPUTVoidWorks() {
//        MockingURLProtocol.mockedResponse =
//        """
//        { "response": "OK" }
//        """
//        let expectationWorks = expectation(description: "Call works")
//        let expectationFinished = expectation(description: "Finished")
//        network.put("/users").sink { completion in
//            switch completion {
//            case .failure(_):
//                XCTFail()
//            case .finished:
//                XCTAssertEqual(MockingURLProtocol.currentRequest?.httpMethod, "PUT")
//                XCTAssertEqual(MockingURLProtocol.currentRequest?.url?.absoluteString, "https://mocked.com/users")
//                expectationFinished.fulfill()
//            }
//        } receiveValue: { () in
//            expectationWorks.fulfill()
//        }
//        .store(in: &cancellables)
//        waitForExpectations(timeout: 0.1)
//    }
    
    @Test
    func PUTVoidAsyncWorks() async throws {
        MockingURLProtocol.mockedResponse =
        """
        { "response": "OK" }
        """
        let _: Void = try await network.put("/users")
        #expect(MockingURLProtocol.currentRequest?.httpMethod == "PUT")
        #expect(MockingURLProtocol.currentRequest?.url?.absoluteString == "https://mocked.com/users")
    }
    
//    func testPUTDataWorks() {
//        MockingURLProtocol.mockedResponse =
//        """
//        { "response": "OK" }
//        """
//        let expectationWorks = expectation(description: "ReceiveValue called")
//        let expectationFinished = expectation(description: "Finished called")
//        network.put("/users").sink { completion in
//            switch completion {
//            case .failure:
//                XCTFail()
//            case .finished:
//                XCTAssertEqual(MockingURLProtocol.currentRequest?.httpMethod, "PUT")
//                XCTAssertEqual(MockingURLProtocol.currentRequest?.url?.absoluteString, "https://mocked.com/users")
//                expectationFinished.fulfill()
//            }
//        } receiveValue: { (data: Data) in
//            XCTAssertEqual(data, MockingURLProtocol.mockedResponse.data(using: String.Encoding.utf8))
//            expectationWorks.fulfill()
//        }
//        .store(in: &cancellables)
//        waitForExpectations(timeout: 0.1)
//    }
    
    @Test
    func PUTDataAsyncWorks() async throws {
        MockingURLProtocol.mockedResponse =
        """
        { "response": "OK" }
        """
        let data: Data = try await network.put("/users")
        #expect(MockingURLProtocol.currentRequest?.httpMethod == "PUT")
        #expect(MockingURLProtocol.currentRequest?.url?.absoluteString == "https://mocked.com/users")
        #expect(data == MockingURLProtocol.mockedResponse.data(using: String.Encoding.utf8))
    }
//    
//    func testPUTJSONWorks() {
//        MockingURLProtocol.mockedResponse =
//        """
//        {"response":"OK"}
//        """
//        let expectationWorks = expectation(description: "ReceiveValue called")
//        let expectationFinished = expectation(description: "Finished called")
//        network.put("/users").sink { completion in
//            switch completion {
//            case .failure:
//                XCTFail()
//            case .finished:
//                XCTAssertEqual(MockingURLProtocol.currentRequest?.httpMethod, "PUT")
//                XCTAssertEqual(MockingURLProtocol.currentRequest?.url?.absoluteString, "https://mocked.com/users")
//                expectationFinished.fulfill()
//            }
//        } receiveValue: { (json: Any) in
//            let data =  try? JSONSerialization.data(withJSONObject: json, options: [])
//            let expectedResponseData =
//            """
//            {"response":"OK"}
//            """.data(using: String.Encoding.utf8)
//
//            XCTAssertEqual(data, expectedResponseData)
//            expectationWorks.fulfill()
//        }
//        .store(in: &cancellables)
//        waitForExpectations(timeout: 0.1)
//    }
    
    @Test
    func PUTJSONAsyncWorks() async throws {
        MockingURLProtocol.mockedResponse =
        """
        {"response":"OK"}
        """
        let json: JSON = try await network.put("/users")
        #expect(MockingURLProtocol.currentRequest?.httpMethod == "PUT")
        #expect(MockingURLProtocol.currentRequest?.url?.absoluteString == "https://mocked.com/users")
        let data =  try? JSONSerialization.data(withJSONObject: json.value, options: [])
        let expectedResponseData =
        """
        {"response":"OK"}
        """.data(using: String.Encoding.utf8)
        #expect(data == expectedResponseData)
    }
//    
//    func testPUTNetworkingJSONDecodableWorks() {
//        MockingURLProtocol.mockedResponse =
//        """
//        {
//            "title":"Hello",
//            "content":"World",
//        }
//        """
//        let expectationWorks = expectation(description: "ReceiveValue called")
//        let expectationFinished = expectation(description: "Finished called")
//        network.put("/posts/1")
//            .sink { completion in
//            switch completion {
//            case .failure:
//                XCTFail()
//            case .finished:
//                XCTAssertEqual(MockingURLProtocol.currentRequest?.httpMethod, "PUT")
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
//    
//    func testPUTDecodableWorks() {
//        MockingURLProtocol.mockedResponse =
//        """
//        {
//            "firstname":"John",
//            "lastname":"Doe",
//        }
//        """
//        let expectationWorks = expectation(description: "ReceiveValue called")
//        let expectationFinished = expectation(description: "Finished called")
//        network.put("/users/1")
//            .sink { completion in
//            switch completion {
//            case .failure:
//                XCTFail()
//            case .finished:
//                XCTAssertEqual(MockingURLProtocol.currentRequest?.httpMethod, "PUT")
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
    
    @Test
    func testPUTDecodableAsyncWorks() async throws {
        MockingURLProtocol.mockedResponse =
        """
        {
            "firstname":"John",
            "lastname":"Doe",
        }
        """
        let user: UserJSON = try await network.put("/users/1")
        #expect(MockingURLProtocol.currentRequest?.httpMethod == "PUT")
        #expect(MockingURLProtocol.currentRequest?.url?.absoluteString == "https://mocked.com/users/1")
        #expect(user.firstname == "John")
        #expect(user.lastname == "Doe")
    }
    
//    func testPUTArrayOfDecodableWorks() {
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
//        network.put("/users")
//            .sink { completion in
//            switch completion {
//            case .failure:
//                XCTFail()
//            case .finished:
//                XCTAssertEqual(MockingURLProtocol.currentRequest?.httpMethod, "PUT")
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
    
    @Test
    func PUTArrayOfDecodableAsyncWorks() async throws {
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
        let users: [UserJSON] = try await network.put("/users")
        #expect(MockingURLProtocol.currentRequest?.httpMethod == "PUT")
        #expect(MockingURLProtocol.currentRequest?.url?.absoluteString == "https://mocked.com/users")
        #expect(users[0].firstname == "John")
        #expect(users[0].lastname == "Doe")
        #expect(users[1].firstname == "Jimmy")
        #expect(users[1].lastname == "Punchline")
    }

//    func testPUTArrayOfDecodableWithKeypathWorks() {
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
//        network.put("/users", keypath: "users")
//            .sink { completion in
//            switch completion {
//            case .failure:
//                XCTFail()
//            case .finished:
//                XCTAssertEqual(MockingURLProtocol.currentRequest?.httpMethod, "PUT")
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
