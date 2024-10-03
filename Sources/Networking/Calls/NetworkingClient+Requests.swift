//
//  NetworkingClient+Requests.swift
//
//
//  Created by Sacha on 13/03/2020.
//

import Foundation

public extension NetworkingClient {

    func getRequest(_ route: String, params: Params = Params()) -> NetworkingRequest {
        createRequest(.get, route, params: params)
    }

    func postRequest(_ route: String, params: Params = Params()) -> NetworkingRequest {
        createRequest(.post, route, params: params)
    }

    func putRequest(_ route: String, params: Params = Params()) -> NetworkingRequest {
        createRequest(.put, route, params: params)
    }
    
    func patchRequest(_ route: String, params: Params = Params()) -> NetworkingRequest {
        createRequest(.patch, route, params: params)
    }

    func deleteRequest(_ route: String, params: Params = Params()) -> NetworkingRequest {
        createRequest(.delete, route, params: params)
    }

    internal func createRequest(_ httpMethod: HTTPMethod,
                          _ route: String,
                          params: Params = Params()
    ) -> NetworkingRequest {
        let req = NetworkingRequest(
            method: httpMethod,
            url: baseURL + route,
            parameterEncoding: parameterEncoding,
            params: params,
            encodableBody: nil,
            headers: headers,
            multipartData: nil,
            timeout: timeout)
        return req
    }
    
    internal func createRequest(_ httpMethod: HTTPMethod,
                          _ route: String,
                          params: Params = Params(),
                          encodableBody: Encodable? = nil
    ) -> NetworkingRequest {
        let req = NetworkingRequest(
            method: httpMethod,
            url: baseURL + route,
            parameterEncoding: parameterEncoding,
            params: params,
            encodableBody: encodableBody,
            headers: headers,
            multipartData: nil,
            timeout: timeout)
        return req
    }
}



