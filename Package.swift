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
            url: "https://github.com/dlocal/dlocal-direct-ios-sdk/releases/download/v4.0.0/DLDirectSDK-4.0.0.zip",
            checksum: "9d84868f260e6bbc9870bc9d71181240d5198cd5f7bbc22bb723df3bf9de6180"
        )
    ]
)
