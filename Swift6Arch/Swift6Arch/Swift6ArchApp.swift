//
//  Swift6ArchApp.swift
//  Swift6Arch
//
//  Created by DURAND SAINT OMER Sacha on 10/2/24.
//

import SwiftUI


@main
struct Swift6ArchApp: App {
    let userService = UserService(userRepository: JSONAPIUserRepository())
    var body: some Scene {
        WindowGroup {
            ContentComponent(userService: userService)
        }
    }
}
