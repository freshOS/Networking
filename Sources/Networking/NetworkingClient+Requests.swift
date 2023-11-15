//
//  NetworkingClient+Requests.swift
//
//
//  Created by Sacha on 13/03/2020.
//

import Foundation
import Combine

public extension NetworkingClient {

    func getRequest(_ route: String, queryParams: Params? = nil) -> NetworkingRequest {
        request(.get, route, queryParams: queryParams)
    }

    func postRequest(_ route: String, body: HTTPBody? = nil) -> NetworkingRequest {
        request(.post, route, body: body)
    }

    func putRequest(_ route: String, body: HTTPBody? = nil) -> NetworkingRequest {
        request(.put, route, body: body)
    }
    
    func patchRequest(_ route: String, body: HTTPBody? = nil) -> NetworkingRequest {
        request(.patch, route, body: body)
    }

    func deleteRequest(_ route: String) -> NetworkingRequest {
        request(.delete, route)
    }

    internal func request(_ httpMethod: HTTPMethod,
                          _ route: String,
                          queryParams: Params? = nil,
                          body: HTTPBody? = nil
    ) -> NetworkingRequest {
        let req = NetworkingRequest()
        req.httpMethod             = httpMethod
        req.route                = route
        req.queryParams = queryParams
        req.httpBody = body
        
        let updateRequest = { [weak req, weak self] in
            guard let self = self else { return }
            req?.baseURL              = self.baseURL
            req?.logLevel             = self.logLevel
            req?.headers              = self.headers
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
