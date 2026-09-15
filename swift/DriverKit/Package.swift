// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "DriverKit",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "DriverKit", targets: ["DriverKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/weichsel/ZIPFoundation.git", from: "0.9.16"),
    ],
    targets: [
        .target(
            name: "DriverKit",
            dependencies: ["ZIPFoundation"]
        ),
        .testTarget(
            name: "DriverKitTests",
            dependencies: ["DriverKit"]
        ),
    ]
)
