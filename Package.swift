// swift-tools-version: 6.2

import PackageDescription

let swiftSettings: [SwiftSetting] = [
    .enableExperimentalFeature("Embedded"),
    .enableExperimentalFeature("LifetimeDependence"),
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
        .trait(name: "RASPI4", enabledTraits: ["RASPI"]),
        .trait(name: "RASPI3", enabledTraits: ["RASPI"]),
        .trait(name: "RASPI2", enabledTraits: ["RASPI"]),
        .trait(name: "RASPI1", enabledTraits: ["RASPI"]),
        "RASPI",
    ],
    targets: [
        .target(
            name: "Kernel",
            dependencies: [
                "Support",
                .byName(name: "RaspberryPi", condition: .when(traits: ["RASPI"])),
            ],
            swiftSettings: swiftSettings,
        ),
        .target(
            name: "RaspberryPi",
            dependencies: ["Font", "Support"],
            swiftSettings: swiftSettings + [
                .enableExperimentalFeature("Volatile")
            ],
        ),
        .target(name: "Font", swiftSettings: swiftSettings),
        .target(name: "Support"),
    ],
)
