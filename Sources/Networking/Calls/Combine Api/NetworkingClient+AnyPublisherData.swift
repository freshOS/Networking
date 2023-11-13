//
//  NetworkingClient+AnyPublisherData.swift
//
//
//  Created by Sacha Durand Saint Omer on 12/11/2023.
//

import Foundation
import Combine

public extension NetworkingClient {

    func post(_ route: String, body: HTTPBody? = nil) -> AnyPublisher<Data, Error> {
        request(.post, route, body: body).publisher()
    }
    
    func put(_ route: String, body: HTTPBody? = nil) -> AnyPublisher<Data, Error> {
        request(.put, route, body: body).publisher()
    }

    func patch(_ route: String, body: HTTPBody? = nil) -> AnyPublisher<Data, Error> {
        request(.patch, route, body: body).publisher()
    }

    func delete(_ route: String) -> AnyPublisher<Data, Error> {
        request(.delete, route).publisher()
    }
}
