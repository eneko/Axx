// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "axx",
    products: [
        .library(name: "AxxCrypto", targets: ["AxxCrypto"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.4.0"),
    ],
    targets: [
        .target(name: "AxxCrypto", dependencies: []),
        .target(name: "axx", dependencies: [
            "AxxCrypto",
            .product(name: "ArgumentParser", package: "swift-argument-parser"),
        ]),
        .testTarget(name: "AxxCryptoTests", dependencies: ["AxxCrypto"]),
        .testTarget(name: "axxTests", dependencies: ["axx"]),
    ]
)
