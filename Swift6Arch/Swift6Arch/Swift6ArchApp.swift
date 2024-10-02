//
//  Swift6ArchApp.swift
//  Swift6Arch
//
//  Created by DURAND SAINT OMER Sacha on 10/2/24.
//

import SwiftUI
import Networking

// Presentation

@main
struct Swift6ArchApp: App {
    
    let userService = UserService(userRepository: JSONAPIUserRepository())
    var body: some Scene {
        WindowGroup {
            ContentComponent(userService: userService)
        }
    }
}

// Domain

class UserService {
    
    let userRepository: UserRepository
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func fetchCurrentUser() async throws -> User {
        return try await userRepository.fetchCurrentUser()
    }
}

protocol UserRepository {
    func fetchCurrentUser() async throws -> User
}


struct User {
    let name: String
}

// Data

struct JSONAPIUserRepository: UserRepository {
    
    let network = NetworkingClient(baseURL: "https://jsonplaceholder.typicode.com")
    
    func fetchCurrentUser() async throws -> User {
        let userJSON: UserJSON = try await network.get("/users/1")
        return User(name: userJSON.name)
    }
}


struct UserJSON: Decodable {
    let name: String
}
