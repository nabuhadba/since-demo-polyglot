// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "tracking-server",
    platforms: [.macOS(.v13)],
    dependencies: [
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.62.0"),
    ],
    targets: [
        .target(
            name: "TrackingCore"
        ),
        .executableTarget(
            name: "tracking-server",
            dependencies: [
                "TrackingCore",
                .product(name: "NIOCore", package: "swift-nio"),
                .product(name: "NIOPosix", package: "swift-nio"),
                .product(name: "NIOHTTP1", package: "swift-nio"),
            ]
        ),
        .testTarget(
            name: "TrackingCoreTests",
            dependencies: ["TrackingCore"]
        ),
    ]
)
