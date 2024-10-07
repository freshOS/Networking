//
//  NetworkingClient+Void.swift
//
//
//  Created by Sacha on 13/03/2020.
//

import Foundation

public extension NetworkingClient {

    func get(_ route: String, params: Params = Params()) async throws {
        _ = try await request(.get, route: route, params: params)
    }
    
    func post(_ route: String, params: Params = Params()) async throws {
        _ = try await request(.post, route: route, params: params)
    }
    
    func post(_ route: String, body: Encodable & Sendable) async throws {
        let req = createRequest(.post, route, encodableBody: body)
        _ = try await execute(request: req)
    }
    
    func put(_ route: String, params: Params = Params()) async throws {
        _ = try await request(.put, route: route, params: params)
    }
    
    func patch(_ route: String, params: Params = Params()) async throws {
        _ = try await request(.patch, route: route, params: params)
    }
    
    func delete(_ route: String, params: Params = Params()) async throws {
        _ = try await request(.delete, route: route, params: params)
    }
}
