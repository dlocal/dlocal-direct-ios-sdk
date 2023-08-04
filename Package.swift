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
            url: "https://github.com/dlocal/dlocal-direct-ios-sdk/releases/download/v0.2.43/DLDirectSDK-0.2.43.zip",
            checksum: "eb202ffa4448cd43ca271867f397699eaaf5f1bd49a6a6f8ffc6032d662c4c4d"
        )
    ]
)
