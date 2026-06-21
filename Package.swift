// swift-tools-version: 6.3

import CompilerPluginSupport
import PackageDescription

let swiftSettings: [SwiftSetting] = [
    .enableExperimentalFeature("Lifetimes"),
    .enableExperimentalFeature("Extern"),
    .enableUpcomingFeature("InternalImportsByDefault"),
    .enableUpcomingFeature("MemberImportVisibility"),
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
    platforms: [.macOS(.v10_15)],
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
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax", "603.0.2"..<"606.0.0")
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
                .target(name: "AsmSupport"),
                .target(name: "KernelMacros"),
            ],
            swiftSettings: swiftSettings,
        ),
        .macro(
            name: "KernelMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
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
