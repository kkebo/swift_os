// swift-tools-version: 6.0

import PackageDescription

let swiftSettings: [SwiftSetting] = [
    .enableExperimentalFeature("Embedded"),
    .unsafeFlags(["-Xfrontend", "-no-allocations"]),
    .unsafeFlags(["-Xfrontend", "-function-sections"]),
    .unsafeFlags(["-Xfrontend", "-disable-stack-protector"]),
]

let package = Package(
    name: "swift_os",
    products: [
        .library(name: "Kernel", type: .static, targets: ["Kernel"])
    ],
    targets: [
        .target(
            name: "Kernel",
            dependencies: [
                "Volatile",
                "MailboxMessage",
                "Support",
            ],
            swiftSettings: swiftSettings + [
                .define("RASPI4")
            ]
        ),
        .systemLibrary(name: "Volatile"),
        .target(name: "MailboxMessage"),
        .target(name: "Support"),
    ],
    swiftLanguageVersions: [.v6]
)
