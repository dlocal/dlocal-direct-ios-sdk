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
            url: "https://github.com/dlocal/dlocal-direct-ios-sdk/releases/download/v1.0.1/DLDirectSDK-1.0.1.zip",
            checksum: "fda60521dac9bf3692fc8ee7b318669e9187099a9ed7351c7b249ae3838a500e"
        )
    ]
)
