////
////  NetworkingClient+Multipart.swift
////
////
////  Created by Sacha on 13/03/2020.
////
//
//import Foundation
//import Combine
//
//public extension NetworkingClient {
//
//    func post(_ route: String,
//              multipartData: MultipartData) -> AnyPublisher<(Data?, Progress), Error> {
//        return post(route, params: params, multipartData: [multipartData])
//    }
//
//    func put(_ route: String,
//             multipartData: MultipartData) -> AnyPublisher<(Data?, Progress), Error> {
//        return put(route, params: params, multipartData: [multipartData])
//    }
//
//    func patch(_ route: String,
//               multipartData: MultipartData) -> AnyPublisher<(Data?, Progress), Error> {
//        return patch(route, params: params, multipartData: [multipartData])
//    }
//
////TODO    // Allow multiple multipart data
//    
//    
//    func post(_ route: String,
//              params: Params = Params(),
//              multipartData: [MultipartData]) -> AnyPublisher<(Data?, Progress), Error> {
//        let req = request(.post, route, params: params)
//        req.body = HTTPBody.multipart(params: params, parts: multipartData)
//        return req.uploadPublisher()
//    }
//
//    func put(_ route: String,
//             params: Params = Params(),
//             multipartData: [MultipartData]) -> AnyPublisher<(Data?, Progress), Error> {
//        let req = request(.put, route, params: params)
//        req.body = HTTPBody.multipart(params: params, parts: multipartData)
//        req.multipartData = multipartData
//        return req.uploadPublisher()
//    }
//
//    func patch(_ route: String,
//               params: Params = Params(),
//               multipartData: [MultipartData]) -> AnyPublisher<(Data?, Progress), Error> {
//        let req = request(.patch, route, params: params)
//        req.multipartData = multipartData
//        return req.uploadPublisher()
//    }
//}

//TODO put back
