// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "axx",
    dependencies: [
        .package(url: "https://github.com/eneko/CommandRegistry.git", from: "0.0.0"),
    ],
    targets: [
        .target(name: "Crypto", dependencies: []),
        .target(name: "axx", dependencies: ["CommandRegistry", "Crypto"]),
        .testTarget(name: "CryptoTests", dependencies: ["Crypto"]),
        .testTarget(name: "axxTests", dependencies: ["axx"]),
    ]
)
