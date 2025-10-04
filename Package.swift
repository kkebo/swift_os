// swift-tools-version: 6.2

import PackageDescription

let swiftSettings: [SwiftSetting] = [
    .enableExperimentalFeature("LifetimeDependence"),
    .enableExperimentalFeature("CDecl"),
    .enableExperimentalFeature("InlineAlways"),
    .enableUpcomingFeature("InternalImportsByDefault"),
    .enableUpcomingFeature("MemberImportVisibility"),
    .unsafeFlags(["-strict-memory-safety"]),
    .treatWarning("StrictMemorySafety", as: .error),
]

let package = Package(
    name: "swift_os",
    products: [
        .executable(name: "Kernel", targets: ["Kernel"])
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
        .executableTarget(
            name: "Kernel",
            dependencies: [
                "Support",
                "AsmSupport",
                .byName(name: "RaspberryPi", condition: .when(traits: ["RASPI"])),
            ],
            swiftSettings: swiftSettings,
        ),
        .target(
            name: "RaspberryPi",
            dependencies: ["Font", "AsmSupport"],
            swiftSettings: swiftSettings + [
                .enableExperimentalFeature("Volatile")
            ],
        ),
        .target(name: "Font", swiftSettings: swiftSettings),
        .target(name: "Support", swiftSettings: swiftSettings),
        .target(name: "AsmSupport"),
    ],
)
