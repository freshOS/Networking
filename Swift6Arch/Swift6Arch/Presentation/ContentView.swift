//
//  ContentView.swift
//  Swift6Arch
//
//  Created by DURAND SAINT OMER Sacha on 10/2/24.
//

import SwiftUI

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
