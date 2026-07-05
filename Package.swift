// swift-tools-version: 6.3

import PackageDescription

let swiftSettings: [SwiftSetting] = [
    .enableExperimentalFeature("Lifetimes"),
    .enableExperimentalFeature("Extern"),
    .enableUpcomingFeature("ExistentialAny"),
    .enableUpcomingFeature("InternalImportsByDefault"),
    .enableUpcomingFeature("MemberImportVisibility"),
    .enableUpcomingFeature("InferIsolatedConformances"),
    .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
    .enableUpcomingFeature("ImmutableWeakCaptures"),
    .strictMemorySafety(),
    .treatAllWarnings(as: .error),
]

let cSettings: [CSetting] = [
    .enableWarning("all"),
    .enableWarning("extra"),
    .treatAllWarnings(as: .error),
]

let package = Package(
    name: "swift_os",
    products: [
        .executable(name: "Kernel", targets: ["Kernel"]),
        .library(name: "KernLibc", targets: ["KernLibc"]),
    ],
    traits: [
        .default(enabledTraits: ["RASPI4"]),
        .trait(name: "RASPI4", enabledTraits: ["RASPI"]),
        .trait(name: "RASPI3", enabledTraits: ["RASPI"]),
        .trait(name: "RASPI2", enabledTraits: ["RASPI"]),
        .trait(name: "RASPI1", enabledTraits: ["RASPI"]),
        .trait(name: "RASPI"),
    ],
    targets: [
        .executableTarget(
            name: "Kernel",
            dependencies: [
                .target(name: "Boot"),
                .target(name: "KernLibc"),
            ],
            swiftSettings: swiftSettings,
        ),
        .target(name: "KernLibc", swiftSettings: swiftSettings),
        .target(name: "Boot", cSettings: cSettings),
        .target(name: "AsmSupport", cSettings: cSettings),
    ],
)
