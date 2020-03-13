//
//  NetworkingClient+Requests.swift
//  
//
//  Created by Sacha on 13/03/2020.
//

import Foundation
import Combine

public extension NetworkingClient {
    
    func getRequest(_ route: String, params: Params = Params()) -> NetworkingRequest {
        request(.get, route, params: params)
    }
    
    func postRequest(_ route: String, params: Params = Params()) -> NetworkingRequest {
        request(.post, route, params: params)
    }
    
    func putRequest(_ route: String, params: Params = Params()) -> NetworkingRequest {
        request(.put, route, params: params)
    }
    
    func deleteRequest(_ route: String, params: Params = Params()) -> NetworkingRequest {
        request(.delete, route, params: params)
    }
    
    internal func request(_: HTTPVerb, _ route: String, params: Params = Params()) -> NetworkingRequest {
        let r = NetworkingRequest()
        r.baseURL = baseURL
        r.logLevels = logLevels
        r.headers = headers
        r.httpVerb = .get
        r.route = route
        r.params = params
        return r
    }
}
