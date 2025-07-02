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

struct FakeAPI: NetworkingService {
    
    internal let network = NetworkingClient(baseURL: "https://mocked.com")
    
    func putUsersVoid() async throws -> Void {
        return try await network.put("/users")
        
//        return try await Request {
//            PUT
//            "/users"
//            Headers([:])
//            Body()
//            Parts(file)
//        }
        // 1 immutable request definition.
        // 2 Declarative ,SwuiftUI like syntax immutable request building engine
        // 3 Make it work !
    }
}

@Suite
struct PutRequestTests {
    
    private let network = NetworkingClient(baseURL: "https://mocked.com")
    private var cancellables = Set<AnyCancellable>()
    
    private let api = FakeAPI()

    init() async {
        await network.sessionConfiguration.protocolClasses = [MockingURLProtocol.self]
    }
    
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
}
