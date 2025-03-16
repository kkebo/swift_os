// swift-tools-version: 6.1

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
    targets: [
        .target(
            name: "Kernel",
            dependencies: [
                "MailboxMessage",
                "Support",
            ],
            swiftSettings: swiftSettings + [
                .define("RASPI4")
            ],
        ),
        .target(name: "MailboxMessage"),
        .target(name: "Support"),
    ],
    swiftLanguageModes: [.v6],
)
