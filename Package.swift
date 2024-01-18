// swift-tools-version: 5.11

import PackageDescription

let package = Package(
    name: "swift_os",
    products: [
        .library(name: "Kernel", type: .static, targets: ["Kernel"])
    ],
    targets: [
        .target(
            name: "Kernel",
            dependencies: [
                "Volatile"
            ],
            swiftSettings: [
                .enableExperimentalFeature("Embedded"),
                .unsafeFlags(["-Xfrontend", "-no-allocations"]),
                .unsafeFlags(["-swift-version", "6"]),
            ]
        ),
        .systemLibrary(name: "Volatile"),
    ]
)
