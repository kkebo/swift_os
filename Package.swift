// swift-tools-version: 6.2

import PackageDescription

let swiftSettings: [SwiftSetting] = [
    .enableExperimentalFeature("Embedded"),
    .enableExperimentalFeature("Volatile"),
    .unsafeFlags(["-Xfrontend", "-no-allocations"]),
    .unsafeFlags(["-Xfrontend", "-function-sections"]),
    .unsafeFlags(["-Xfrontend", "-disable-stack-protector"]),
    .unsafeFlags(["-strict-memory-safety"]),
]

let package = Package(
    name: "swift_os",
    products: [
        .library(name: "Kernel", type: .static, targets: ["Kernel"])
    ],
    traits: [
        .default(enabledTraits: ["RASPI4"]),
        "RASPI4",
        "RASPI3",
        "RASPI2",
        "RASPI1",
    ],
    targets: [
        .target(
            name: "Kernel",
            dependencies: [
                "Support"
            ],
            swiftSettings: swiftSettings,
        ),
        .target(name: "Support"),
    ],
)
