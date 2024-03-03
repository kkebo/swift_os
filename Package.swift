// swift-tools-version: 6.0

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
                .unsafeFlags(["-Xfrontend", "-disable-stack-protector"]),
                .unsafeFlags(["-swift-version", "6"]),
                .define("RASPI3"),
            ]
        ),
        .systemLibrary(name: "Volatile"),
    ]
)
