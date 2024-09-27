//
//  NetworkingClient+JSON.swift
//
//
//  Created by Sacha on 13/03/2020.
//

import Foundation

public extension NetworkingClient {
    
    func get(_ route: String, params: Params = Params()) async throws -> Any {
        let req = request(.get, route, params: params)
        let data = try await execute(request: req)
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        return json
    }

    func get(_ route: String, params: Params = Params()) async throws -> JSON {
        let req = request(.get, route, params: params)
        let data = try await execute(request: req)
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        return JSON(jsonObject: json)
    }
    
    func post(_ route: String, params: Params = Params()) async throws -> JSON {
        let req = request(.post, route, params: params)
        let data = try await execute(request: req)
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        return JSON(jsonObject: json)
    }
    
    func post(_ route: String, body: Encodable) async throws -> JSON {
        let req = request(.post, route, encodableBody: body)
        let data = try await execute(request: req)
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        return JSON(jsonObject: json)
    }
    
    func put(_ route: String, params: Params = Params()) async throws -> JSON {
        let req = request(.put, route, params: params)
        let data = try await execute(request: req)
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        return JSON(jsonObject: json)
    }
    
    func patch(_ route: String, params: Params = Params()) async throws -> Any {
        let req = request(.patch, route, params: params)
        let data = try await execute(request: req)
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        return json
    }
    
    func patch(_ route: String, params: Params = Params()) async throws -> JSON {
        let req = request(.patch, route, params: params)
        let data = try await execute(request: req)
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        return JSON(jsonObject: json)
    }
    
    func patch(_ route: String, body: Encodable) async throws -> JSON {
        let req = request(.patch, route, encodableBody: body)
        let data = try await execute(request: req)
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        return JSON(jsonObject: json)
    }
    
    func delete(_ route: String, params: Params = Params()) async throws -> JSON {
        let req = request(.delete, route, params: params)
        let data = try await execute(request: req)
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        return JSON(jsonObject: json)
    }
}

