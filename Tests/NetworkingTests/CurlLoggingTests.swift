//
//  CurlLoggingTests.swift
//  
//
//  Created by Maxence Levelu on 25/01/2021.
//

import Testing
import Foundation

@Suite
struct CurlLoggingTests {
    
    @Test
    func logGet() {
        var urlRequest = URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com")!)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("token", forHTTPHeaderField: "Authorization")
        let result = urlRequest.toCurlCommand()
        #expect(result == "curl \"https://jsonplaceholder.typicode.com\" \\\n\t-H 'Authorization: token'")
    }
    
    @Test
    func logPost() {
        var urlRequest = URLRequest(url: URL(string:
            "https://jsonplaceholder.typicode.com/posts")!)
        urlRequest.httpMethod = "POST"
        let jsonString = """
        {"title": "Hello world"}
        """
        urlRequest.httpBody = jsonString.data(using: .utf8)
        let result = urlRequest.toCurlCommand()
        #expect(result == "curl \"https://jsonplaceholder.typicode.com/posts\" \\\n\t-X POST \\\n\t-d '{\"title\": \"Hello world\"}'")
    }
    
    @Test
    func logPut() {
        var urlRequest = URLRequest(url: URL(string:
            "https://jsonplaceholder.typicode.com/posts")!)
        urlRequest.httpMethod = "PUT"
        let jsonString = """
        {"title": "Hello world"}
        """
        urlRequest.httpBody = jsonString.data(using: .utf8)
        let result = urlRequest.toCurlCommand()
        #expect(result == "curl \"https://jsonplaceholder.typicode.com/posts\" \\\n\t-X PUT \\\n\t-d '{\"title\": \"Hello world\"}'")
    }
    
    @Test
    func logPatch() {
        var urlRequest = URLRequest(url: URL(string:
            "https://jsonplaceholder.typicode.com/posts")!)
        urlRequest.httpMethod = "PATCH"
        let jsonString = """
        {"title": "Hello world"}
        """
        urlRequest.httpBody = jsonString.data(using: .utf8)
        let result = urlRequest.toCurlCommand()
        #expect(result == "curl \"https://jsonplaceholder.typicode.com/posts\" \\\n\t-X PATCH \\\n\t-d '{\"title\": \"Hello world\"}'")
    }
    
    @Test
    func logDelete() {
        var urlRequest = URLRequest(url: URL(string:
            "https://jsonplaceholder.typicode.com/posts/1")!)
        urlRequest.httpMethod = "DELETE"
        let result = urlRequest.toCurlCommand()
        #expect(result == "curl \"https://jsonplaceholder.typicode.com/posts/1\" \\\n\t-X DELETE")
    }
}
