// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Networking",
    platforms: [.iOS(.v13)],
    products: [.library(name: "Networking", targets: ["Networking"])],
    targets: [
        .target(name: "Networking", dependencies: []),
        .testTarget(name: "NetworkingTests", dependencies: ["Networking"]),
    ]
)
