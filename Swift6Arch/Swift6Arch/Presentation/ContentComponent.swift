//
//  ContentComponent.swift
//  Swift6Arch
//
//  Created by Sacha Durand Saint Omer on 05/10/2024.
//

import SwiftUI

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
