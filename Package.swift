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
    .treatWarning("HeapAllocation", as: .error),
]
let earlySwiftSettings = swiftSettings + [.unsafeFlags(["-Xcc", "-mno-unaligned-access"])]

let cSettings: [CSetting] = [
    .enableWarning("all"),
    .enableWarning("extra"),
    .treatAllWarnings(as: .error),
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
        .trait(name: "RASPI"),
    ],
    targets: [
        .executableTarget(
            name: "Kernel",
            dependencies: [
                .target(name: "Boot"),
                .target(name: "EarlyKernel"),
                .target(name: "EarlyArchAArch64"),
                .target(name: "KernelCore"),
                .target(name: "KernLibc"),
                .target(name: "AsmSupport"),
                .target(name: "ArchAArch64"),
                .target(name: "RaspberryPi", condition: .when(traits: ["RASPI"])),
            ],
            swiftSettings: swiftSettings,
        ),
        .target(
            name: "EarlyKernel",
            dependencies: [
                .target(name: "LinkerSupport")
            ],
            swiftSettings: earlySwiftSettings,
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
            name: "EarlyArchAArch64",
            dependencies: [
                .target(name: "AsmSupport"),
                .target(name: "LinkerSupport"),
            ],
            swiftSettings: earlySwiftSettings,
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
                .target(name: "ArchAArch64"),
            ],
            swiftSettings: swiftSettings + [
                .enableExperimentalFeature("Volatile")
            ],
        ),
        .target(name: "LinkerSupport", cSettings: cSettings),
        .target(name: "Boot", cSettings: cSettings),
        .target(name: "AsmSupport", cSettings: cSettings),
        .target(name: "AppLibc", swiftSettings: swiftSettings),
    ],
)
