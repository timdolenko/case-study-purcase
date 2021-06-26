// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CoreTools",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "CoreTools",
            targets: ["CoreTools"]),
        .library(
            name: "CoreUI",
            targets: ["CoreUI"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "CoreTools",
            dependencies: []),
        .testTarget(
            name: "CoreToolsTests",
            dependencies: ["CoreTools"]),
        
        .target(
            name: "CoreUI",
            dependencies: []),
    ]
)
