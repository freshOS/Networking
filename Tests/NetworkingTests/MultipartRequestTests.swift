//
//  MultipartRequestTests.swift
//  
//
//  Created by Jeff Barg on 7/22/20.
//

import Foundation
import Testing
import Combine

@testable
import Networking

@Suite
final class MultipartRequestTests {
    
    let baseClient: NetworkingClient = NetworkingClient(baseURL: "https://example.com/")
    let route = "/api/test"

    @Test
    func RequestGenerationWithSingleFile() async {
        // Set up test
        let params: Params = [:]
        let multipartData = MultipartData(name: "test_name",
                                          fileData: "test data".data(using: .utf8)!,
                                          fileName: "file.txt",
                                          mimeType: "text/plain")

        // Construct request
        var request = baseClient.createRequest(.post, route, params: params)
        request.multipartData = [multipartData]

        if let urlRequest = request.buildURLRequest(),
           let body = urlRequest.httpBody,
           let contentTypeHeader = urlRequest.value(forHTTPHeaderField: "Content-Type") {
            // Extract boundary from header
            #expect(contentTypeHeader.starts(with: "multipart/form-data; boundary="))
            let boundary = contentTypeHeader.replacingOccurrences(of: "multipart/form-data; boundary=", with: "")

            // Test correct body construction
            let expectedBody = "--\(boundary)\r\nContent-Disposition: form-data; name=\"test_name\"; " +
            "filename=\"file.txt\"\r\nContent-Type: text/plain\r\n\r\ntest data\r\n--\(boundary)--"
            let actualBody = String(data: body, encoding: .utf8)
            #expect(actualBody == expectedBody)
        } else {
            Issue.record("Properly-formed URL request was not constructed")
        }
    }

    @Test
    func requestGenerationWithParams() async {
        // Set up test
        let params: Params = ["test_name": "test_value"]
        let multipartData = MultipartData(name: "test_name",
                                          fileData: "test data".data(using: .utf8)!,
                                          fileName: "file.txt",
                                          mimeType: "text/plain")

        // Construct request
        var request = baseClient.createRequest(.post, route, params: params)
        request.multipartData = [multipartData]

        if let urlRequest = request.buildURLRequest(),
           let body = urlRequest.httpBody,
           let contentTypeHeader = urlRequest.value(forHTTPHeaderField: "Content-Type") {
            // Extract boundary from header
            #expect(contentTypeHeader.starts(with: "multipart/form-data; boundary="))
            let boundary = contentTypeHeader.replacingOccurrences(of: "multipart/form-data; boundary=", with: "")

            // Test correct body construction
            let expectedBody = "--\(boundary)\r\nContent-Disposition: " +
            "form-data; name=\"test_name\"\r\n\r\ntest_value\r\n--\(boundary)\r\nContent-Disposition: form-data; " +
            "name=\"test_name\"; filename=\"file.txt\"\r\nContent-Type: text/plain\r\n\r\ntest data\r\n--\(boundary)--"
            let actualBody = String(data: body, encoding: .utf8)
            #expect(actualBody == expectedBody)
        } else {
            Issue.record("Properly-formed URL request was not constructed")
        }
    }

    @Test
    func requestGenerationWithMultipleFiles() async {
        // Set up test
        let params: Params = [:]
        let multipartData = [
            MultipartData(name: "test_name",
                          fileData: "test data".data(using: .utf8)!,
                          fileName: "file.txt",
                          mimeType: "text/plain"),
            MultipartData(name: "second_name",
                          fileData: "another file".data(using: .utf8)!,
                          fileName: "file2.txt",
                          mimeType: "text/plain")
        ]

        // Construct request
        var request = baseClient.createRequest(.post, route, params: params)
        request.multipartData = multipartData

        if let urlRequest = request.buildURLRequest(),
           let body = urlRequest.httpBody,
           let contentTypeHeader = urlRequest.value(forHTTPHeaderField: "Content-Type") {
            // Extract boundary from header
            #expect(contentTypeHeader.starts(with: "multipart/form-data; boundary="))
            let boundary = contentTypeHeader.replacingOccurrences(of: "multipart/form-data; boundary=", with: "")

            // Test correct body construction
            let expectedBody = "--\(boundary)\r\nContent-Disposition: form-data; name=\"test_name\"; " +
            "filename=\"file.txt\"\r\nContent-Type: text/plain\r\n\r\ntest " +
            "data\r\n--\(boundary)\r\nContent-Disposition: form-data; name=\"second_name\"; " +
            "filename=\"file2.txt\"\r\nContent-Type: text/plain\r\n\r\nanother file\r\n--\(boundary)--"
            let actualBody = String(data: body, encoding: .utf8)
            #expect(actualBody == expectedBody)
        } else {
            Issue.record("Properly-formed URL request was not constructed")
        }
    }
}
