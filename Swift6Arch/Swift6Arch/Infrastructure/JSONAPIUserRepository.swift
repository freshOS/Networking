//
//  JSONAPIUserRepository.swift
//  Swift6Arch
//
//  Created by Sacha Durand Saint Omer on 05/10/2024.
//

import Foundation
import Networking

struct JSONAPIUserRepository: UserRepository {
    
    let network = NetworkingClient(baseURL: "https://jsonplaceholder.typicode.com")
    
    func fetchCurrentUser() async throws -> User {
        let userJSON: UserJSON = try await network.get("/users/1")
        return User(name: userJSON.name)
    }
}
