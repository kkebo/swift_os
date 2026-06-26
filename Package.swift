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
    .unsafeFlags(["-strict-memory-safety"]),
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
        .library(name: "AppLibc", targets: ["AppLibc"]),
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
                .target(name: "KernelCore"),
                .target(name: "KernLibc"),
                .target(name: "AsmSupport"),
                .target(name: "LinkerSupport"),
                .target(name: "ArchAArch64"),
                .target(name: "RaspberryPi", condition: .when(traits: ["RASPI"])),
            ],
            swiftSettings: swiftSettings,
        ),
        .target(
            name: "KernelCore",
            dependencies: [
                .target(name: "Hardware")
            ],
            swiftSettings: swiftSettings,
        ),
        .target(
            name: "ArchAArch64",
            dependencies: [
                .target(name: "AsmSupport")
            ],
            swiftSettings: swiftSettings,
        ),
        .target(
            name: "Hardware",
            swiftSettings: swiftSettings + [
                .enableExperimentalFeature("Volatile")
            ],
        ),
        .target(name: "KernLibc", swiftSettings: swiftSettings),
        .target(
            name: "RaspberryPi",
            dependencies: [
                .target(name: "Hardware"),
                .target(name: "AsmSupport"),
                .target(name: "LinkerSupport"),
            ],
            swiftSettings: swiftSettings + [
                .enableExperimentalFeature("Volatile")
            ],
        ),
        .target(name: "LinkerSupport", swiftSettings: swiftSettings),
        .target(name: "Boot", cSettings: cSettings),
        .target(name: "AsmSupport", cSettings: cSettings),
        .target(name: "AppLibc", swiftSettings: swiftSettings),
    ],
)
