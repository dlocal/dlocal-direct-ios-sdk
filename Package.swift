// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DLDirectSDK",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "DLDirectSDK",
            targets: ["DLDirectSDK"])
    ],
    targets: [
        .binaryTarget(
            name: "DLDirectSDK",
            url: "https://github.com/dlocal/dlocal-direct-ios-sdk/releases/download/v3.0.13/DLDirectSDK-3.0.13.zip",
            checksum: "ebdfd8387fb081b13c81e1f5a7c9acffcc221c8619c090a4ba908a6b8a8a77d0"
        )
    ]
)
