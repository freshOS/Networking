// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Networking",
    platforms: [.iOS(.v13), .macOS(.v10_15), .watchOS(.v6)],
    products: [.library(name: "Networking", targets: ["Networking"])],
    targets: [
        .target(name: "Networking"),
        .testTarget(name: "NetworkingTests", dependencies: ["Networking"])
    ]
)
