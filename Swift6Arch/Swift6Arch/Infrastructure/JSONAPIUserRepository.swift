//
//  JSONAPIUserRepository.swift
//  Swift6Arch
//
//  Created by Sacha Durand Saint Omer on 05/10/2024.
//

import Foundation
import Networking

struct JSONAPIUserRepository: UserRepository, NetworkingService {
    
	let network: NetworkingClient
	
	init(client: NetworkingClient) {
		self.network = client
	}
    
    func fetchCurrentUser() async throws -> User {
        let userJSON: UserJSON = try await get("/users/1")
        return User(name: userJSON.name)
    }
}
