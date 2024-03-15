// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "CoraNetwork",
    products: [
        .library(
            name: "CoraNetwork",
            targets: ["CoraNetwork"]),
    ],
    dependencies: [
        .package(path: "../CoraSecurity")
    ],
    targets: [
        .target(
            name: "CoraNetwork",
            dependencies: ["CoraSecurity"]),
        .testTarget(
            name: "CoraNetworkTests",
            dependencies: ["CoraNetwork"]),
    ]
)
