//
//  MockingURLProtocol.swift
//  
//
//  Created by Sacha DSO on 12/04/2022.
//

import Foundation

class MockingURLProtocol: URLProtocol {
    
    static var mockedResponse = ""
    static var currentRequest: URLRequest?
    
    override class func canInit(with request: URLRequest) -> Bool {
        currentRequest = request
        return request.url?.host == "mocked.com"
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        let data = MockingURLProtocol.mockedResponse.data(using: String.Encoding.utf8)
        DispatchQueue.global(qos: .default).async {
            self.client?.urlProtocol(self, didLoad: data!)
            self.client?.urlProtocol(self, didReceive: URLResponse(), cacheStoragePolicy: URLCache.StoragePolicy.allowed)
            self.client?.urlProtocolDidFinishLoading(self)
        }
    }
    
    override func stopLoading() { }
}


extension Data {
    init(inputStream: InputStream) throws {
        inputStream.open()
        defer { inputStream.close() }
        self.init()
        let bufferSize = 512
        var readBuffer = [UInt8](repeating: 0, count: bufferSize)
        while inputStream.hasBytesAvailable {
            let readBytes = inputStream.read(&readBuffer, maxLength: bufferSize)
            switch readBytes {
            case 0:
                break
            case ..<0:
                throw inputStream.streamError!
            default:
                append(readBuffer, count: readBytes)
            }
        }
    }
}


extension URLRequest {
    func httpBodyStreamAsData() -> Data? {
        guard let httpBodyStream else { return nil }
        do {
            return try Data(inputStream: httpBodyStream)
        } catch {
            return nil
        }
    }
    
    func httpBodyStreamAsJSON() -> Any? {
        guard let httpBodyStreamAsData = httpBodyStreamAsData() else { return nil }
        do {
            let json = try JSONSerialization.jsonObject(with: httpBodyStreamAsData)
            return json
        } catch {
            return nil
        }
    }
    
    func httpBodyStreamAsDictionary() -> [String: Any] {
        return httpBodyStreamAsJSON() as? [String: Any] ?? [:]
    }
}
