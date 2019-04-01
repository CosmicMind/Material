// swift-tools-version:4.2
import PackageDescription

let package = Package(
    name: "Material",
    // platforms: [.iOS("8.0")],
    products: [
        .library(name: "Material", targets: ["Material"])
    ],
    targets: [
        .target(
            name: "Material",
            path: "Sources"
        )
    ]
)
