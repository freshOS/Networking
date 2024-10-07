//
//  UserService.swift
//  Swift6Arch
//
//  Created by Sacha Durand Saint Omer on 05/10/2024.
//

import Foundation

struct UserService {
    
    let userRepository: UserRepository
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func fetchCurrentUser() async throws -> User {
        return try await userRepository.fetchCurrentUser()
    }
}
