// swift-tools-version:6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GiphyUISDK",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "GiphyUISDK",
            targets: ["GiphyUISDKWrapper"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SDWebImage/libwebp-Xcode", from: "1.1.0")
    ],
    targets: [
        .binaryTarget(
            name: "GiphyUISDK",
            path: "GiphyUISDK.xcframework"),
        .target(
            name: "GiphyUISDKWrapper",
            dependencies: [
                .target(name: "GiphyUISDK"),
                .product(name: "libwebp", package: "libwebp-Xcode")
            ],
            path: "./Sources"
        ),
    ]
)
