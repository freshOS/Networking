//
//  UserRepository.swift
//  Swift6Arch
//
//  Created by Sacha Durand Saint Omer on 05/10/2024.
//

import Foundation

protocol UserRepository: Sendable {
    func fetchCurrentUser() async throws -> User
}
