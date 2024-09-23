// swift-tools-version: 5.8.1

import PackageDescription

let package = Package(
    name: "swift-package-ios-build-test",

    platforms: [
        .iOS(.v14),
        .macOS(.v11)
    ],

    products: [
        .library(
            name: "swift-package-ios-build-test",
            type: .dynamic,
            targets: ["swift-package-ios-build-test"]
        ),
    ],

    targets: [
        .target(
            name: "swift-package-ios-build-test"
        ),
    ]
)
