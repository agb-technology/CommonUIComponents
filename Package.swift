// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CommonUIComponents",
    platforms: [ .iOS(.v16) ],
    products: [
        .library(
            name: "CommonUIComponents",
            targets: ["CommonUIComponents"]
        ),
    ],
    dependencies: [
        // Kingfisher
        .package(url: "https://github.com/onevcat/Kingfisher.git", exact: "8.6.0"),
        // 自定义通用工具库
        .package(url: "https://github.com/agb-technology/Utilities.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "CommonUIComponents",
            dependencies: [
                // 图片加载和缓存库 - 提供高效的网络图片下载、缓存和显示功能
                .product(name: "Kingfisher", package: "Kingfisher"),
                // 自定义通用工具
                .product(name: "Utilities", package: "Utilities")
            ],
            resources: [ .process("Resources") ]
        ),
    ]
)
