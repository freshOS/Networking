//
//  Swift6ArchApp.swift
//  Swift6Arch
//
//  Created by DURAND SAINT OMER Sacha on 10/2/24.
//

import SwiftUI
import Networking


@main
struct Swift6ArchApp: App {
	let userService = UserService(userRepository: JSONAPIUserRepository(client: NetworkingClient(baseURL: "https://jsonplaceholder.typicode.com")))
    var body: some Scene {
        WindowGroup {
            ContentComponent(userService: userService)
		}
    }
}
