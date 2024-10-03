//
//  DeleteRequestTests.swift
//  
//
//  Created by Sacha DSO on 12/04/2022.
//

import Testing
import Combine
import Foundation
import Networking

@Suite(.serialized)
class DeleteRequestCombineTests {
    
    private let network = NetworkingClient(baseURL: "https://mocked.com")
    private var cancellables = Set<AnyCancellable>()

    init() {
        network.sessionConfiguration.protocolClasses = [MockingURLProtocol.self]
    }

    @Test
    func DELETEVoidWorks() async {
        MockingURLProtocol.mockedResponse =
        """
        { "response": "OK" }
        """
        _ = await withCheckedContinuation { continuation in
            network.delete("/users").sink { completion in
                switch completion {
                case .failure(_):
                    Issue.record("failure")
                case .finished:
                    print("finished")
                }
            } receiveValue: { () in
                continuation.resume(returning: ())
            }
            .store(in: &cancellables)
        }
        #expect(MockingURLProtocol.currentRequest?.httpMethod == "DELETE")
        #expect(MockingURLProtocol.currentRequest?.url?.absoluteString == "https://mocked.com/users")
    }

    @Test
    func DELETEDataWorks() async {
        MockingURLProtocol.mockedResponse =
        """
        { "response": "OK" }
        """
        let result = await withCheckedContinuation { continuation in
            network.delete("/users").sink { completion in
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
        #expect(result != nil)
        #expect(MockingURLProtocol.currentRequest?.httpMethod == "DELETE")
        #expect(MockingURLProtocol.currentRequest?.url?.absoluteString == "https://mocked.com/users")
    }
    
    @Test
    func DELETEJSONWorks() async {
        MockingURLProtocol.mockedResponse =
        """
        {"response":"OK"}
        """
        let result = await withCheckedContinuation { continuation in
            network.delete("/users").sink { completion in
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
        #expect(MockingURLProtocol.currentRequest?.httpMethod == "DELETE")
        #expect(MockingURLProtocol.currentRequest?.url?.absoluteString == "https://mocked.com/users")
        let data =  try? JSONSerialization.data(withJSONObject: result, options: [])
        let expectedResponseData =
        """
        {"response":"OK"}
        """.data(using: String.Encoding.utf8)
        
        #expect(data == expectedResponseData)
    }
    
//    func testDELETENetworkingJSONDecodableWorks() {
//        MockingURLProtocol.mockedResponse =
//        """
//        {
//            "title":"Hello",
//            "content":"World",
//        }
//        """
//        let expectationWorks = expectation(description: "ReceiveValue called")
//        let expectationFinished = expectation(description: "Finished called")
//        network.delete("/posts/1")
//            .sink { completion in
//            switch completion {
//            case .failure:
//                XCTFail()
//            case .finished:
//                XCTAssertEqual(MockingURLProtocol.currentRequest?.httpMethod, "DELETE")
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
    
//    func testDELETEDecodableWorks() {
//        MockingURLProtocol.mockedResponse =
//        """
//        {
//            "firstname":"John",
//            "lastname":"Doe",
//        }
//        """
//        let expectationWorks = expectation(description: "ReceiveValue called")
//        let expectationFinished = expectation(description: "Finished called")
//        network.delete("/users/1")
//            .sink { completion in
//            switch completion {
//            case .failure:
//                XCTFail()
//            case .finished:
//                XCTAssertEqual(MockingURLProtocol.currentRequest?.httpMethod, "DELETE")
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
//
//    func testDELETEArrayOfDecodableWorks() {
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
//        network.delete("/users")
//            .sink { completion in
//            switch completion {
//            case .failure:
//                XCTFail()
//            case .finished:
//                XCTAssertEqual(MockingURLProtocol.currentRequest?.httpMethod, "DELETE")
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

//    func testDELETEArrayOfDecodableWithKeypathWorks() {
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
//        network.delete("/users", keypath: "users")
//            .sink { completion in
//            switch completion {
//            case .failure:
//                XCTFail()
//            case .finished:
//                XCTAssertEqual(MockingURLProtocol.currentRequest?.httpMethod, "DELETE")
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
