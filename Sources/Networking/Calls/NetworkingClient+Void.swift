//
//  NetworkingClient+Void.swift
//
//
//  Created by Sacha on 13/03/2020.
//

import Foundation

public extension NetworkingClient {

    func get(_ route: String, params: Params = Params()) async throws {
        let req = request(.get, route, params: params)
        _ = try await execute(request: req)
    }
    
    func post(_ route: String, params: Params = Params()) async throws {
        let req = request(.post, route, params: params)
        _ = try await execute(request: req)
    }
    
    func post(_ route: String, body: Encodable) async throws {
        let req = request(.post, route, encodableBody: body)
        _ = try await execute(request: req)
    }
    
    func put(_ route: String, params: Params = Params()) async throws {
        let req = request(.put, route, params: params)
        _ = try await execute(request: req)
    }
    
    func patch(_ route: String, params: Params = Params()) async throws {
        let req = request(.patch, route, params: params)
        _ = try await execute(request: req)
    }
    
    func delete(_ route: String, params: Params = Params()) async throws {
        let req = request(.delete, route, params: params)
        _ = try await execute(request: req)
    }
}
