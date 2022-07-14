//
//  NetworkingClient+Requests.swift
//
//
//  Created by Sacha on 13/03/2020.
//

import Foundation
import Combine

public extension NetworkingClient {

    func getRequest(_ route: String, params: Params = Params()) -> NetworkingRequest<String> {
        request(.get, route, params: params)
    }

    func postRequest(_ route: String, params: Params = Params()) -> NetworkingRequest<String> {
        request(.post, route, params: params)
    }

    func putRequest(_ route: String, params: Params = Params()) -> NetworkingRequest<String> {
        request(.put, route, params: params)
    }
    
    func patchRequest(_ route: String, params: Params = Params()) -> NetworkingRequest<String> {
        request(.patch, route, params: params)
    }

    func deleteRequest(_ route: String, params: Params = Params()) -> NetworkingRequest<String> {
        request(.delete, route, params: params)
    }

    internal func request(_ httpMethod: HTTPMethod,
                          _ route: String,
                          params: Params = Params()
    ) -> NetworkingRequest<String> {
        let req = NetworkingRequest<String>()
        req.httpMethod             = httpMethod
        req.route                = route
        req.params               = params
        
        let updateRequest = { [weak req, weak self] in
            guard let self = self else { return }
            req?.baseURL              = self.baseURL
            req?.logLevel             = self.logLevel
            req?.headers              = self.headers
            req?.parameterEncoding    = self.parameterEncoding
            req?.sessionConfiguration = self.sessionConfiguration
            req?.timeout              = self.timeout
        }
        updateRequest()
        req.requestRetrier = { [weak self] in
            self?.requestRetrier?($0, $1)?
                .handleEvents(receiveOutput: { _ in
                    updateRequest()
                })
                .eraseToAnyPublisher()
        }
        return req
    }
    
    internal func request<E: Encodable>(_ httpMethod: HTTPMethod,
                          _ route: String,
                          params: Params = Params(),
                          encodableParams: E? = nil
    ) -> NetworkingRequest<E> {
        let req = NetworkingRequest<E>()
        req.httpMethod             = httpMethod
        req.route                = route
        req.params               = Params()
        req.encodableParams      = encodableParams
        
        let updateRequest = { [weak req, weak self] in
            guard let self = self else { return }
            req?.baseURL              = self.baseURL
            req?.logLevel             = self.logLevel
            req?.headers              = self.headers
            req?.parameterEncoding    = self.parameterEncoding
            req?.sessionConfiguration = self.sessionConfiguration
            req?.timeout              = self.timeout
        }
        updateRequest()
        req.requestRetrier = { [weak self] in
            self?.requestRetrier?($0, $1)?
                .handleEvents(receiveOutput: { _ in
                    updateRequest()
                })
                .eraseToAnyPublisher()
        }
        return req
    }
}
