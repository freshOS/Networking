//
//  NetworkingClient+JSON.swift
//
//
//  Created by Sacha on 13/03/2020.
//

import Foundation

public extension NetworkingClient {
    
    func get(_ route: String, params: Params = Params()) async throws -> Any {
        let data = try await request(.get, route: route, params: params)
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        return json
    }

    func get(_ route: String, params: Params = Params()) async throws -> JSON {
        return JSON(jsonObject: try await get(route, params: params))
    }
    
    func post(_ route: String, params: Params = Params()) async throws -> JSON {
        let data = try await request(.post, route: route, params: params)
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        return JSON(jsonObject: json)
    }
    
    func post(_ route: String, body: Encodable) async throws -> JSON {
        let req = createRequest(.post, route, encodableBody: body)
        let data = try await execute(request: req)
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        return JSON(jsonObject: json)
    }
    
    func put(_ route: String, params: Params = Params()) async throws -> JSON {
        let data = try await request(.put, route: route, params: params)
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        return JSON(jsonObject: json)
    }
    
    func patch(_ route: String, params: Params = Params()) async throws -> Any {
        let data = try await request(.patch, route: route, params: params)
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        return json
    }
    
    func patch(_ route: String, params: Params = Params()) async throws -> JSON {
        return JSON(jsonObject: try await patch(route, params: params))
    }
    
    func patch(_ route: String, body: Encodable) async throws -> JSON {
        let req = createRequest(.patch, route, encodableBody: body)
        let data = try await execute(request: req)
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        return JSON(jsonObject: json)
    }
    
    func delete(_ route: String, params: Params = Params()) async throws -> JSON {
        let data = try await request(.delete, route: route, params: params)
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        return JSON(jsonObject: json)
    }
}

