//
//  ContentViewModel.swift
//  Swift6Arch
//
//  Created by Sacha Durand Saint Omer on 05/10/2024.
//

import Observation

@MainActor
@Observable
class ContentViewModel {
    
    var username = "default"
    var isLoading = false
    
    private let userService: UserService
    
    init(userService: UserService) {
        self.userService = userService
    }
    
    func fetchUser() {
        Task { @MainActor [userService] in
            do {
                isLoading = true
                let fetchedUser = try await userService.fetchCurrentUser()
                username = fetchedUser.name
                isLoading = false
            } catch {
                isLoading = false
                print("error")
            }
        }
    }
}
