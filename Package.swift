// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GiphyUISDK",
    products: [
        .library(
            name: "GiphyUISDK",
            targets: ["GiphyUISDKWrapper"]),
    ],
    dependencies: [
        .package(name: "libwebp", url: "https://github.com/SDWebImage/libwebp-Xcode", from: "1.1.0")
    ],
    targets: [
        .binaryTarget(
            name: "GiphyUISDK",
            path: "GiphyUISDK.xcframework"),
        .target(
            name: "GiphyUISDKWrapper",
            dependencies: [
            ],
            path: "./Sources"
        ),
    ]
)
