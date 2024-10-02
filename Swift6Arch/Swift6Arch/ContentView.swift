//
//  ContentView.swift
//  Swift6Arch
//
//  Created by DURAND SAINT OMER Sacha on 10/2/24.
//

import SwiftUI

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

struct ContentComponent: View {
    
    @State var viewModel: ContentViewModel
    
    init(userService: UserService) {
        viewModel = ContentViewModel(userService: userService)
    }
    
    var body: some View {
        ContentView(username: viewModel.username,
                    isLoading: viewModel.isLoading,
                    didTapFetchUsername: viewModel.fetchUser)
    }
}


struct ContentView: View {
    
    let username: String
    let isLoading: Bool
    let didTapFetchUsername: () -> Void
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            
            if isLoading {
                ProgressView()
            }
            Text(username)
            Button("Fetch username") {
                didTapFetchUsername()
            }
        }
        .padding()
    }
}


#Preview {
    ContentView(username: "John", isLoading: false, didTapFetchUsername: {})
}
