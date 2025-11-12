// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WWCustomerService",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "WWCustomerService", targets: ["WWCustomerService"]),
    ],
    targets: [
        .target(name: "WWCustomerService", resources: [.copy("Privacy")]),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
