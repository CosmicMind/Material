// swift-tools-version:4.2
import PackageDescription

let package = Package(
    name: "Material",
    // platforms: [.iOS("8.0")],
    products: [
        .library(name: "Material", targets: ["Material"])
    ],
    dependencies: [
        .package(url: "https://github.com/AccioSupport/Motion.git"),
    ],
    targets: [
        .target(
            name: "Material",
            dependencies: ["Motion"],
            path: "Sources"
        )
    ]
)
