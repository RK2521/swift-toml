// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "TOML",
    platforms: [
        .macOS(.v10_15),
        .macCatalyst(.v13),
        .iOS(.v13),
        .watchOS(.v6),
        .tvOS(.v13),
        .visionOS(.v1),
    ],
    products: [
        .library(
            name: "TOML",
            targets: ["TOML"]
        )
    ],
    targets: [
        .target(
            name: "CTomlPlusPlus",
            path: "Sources/CTomlPlusPlus",
            publicHeadersPath: "include",
            cxxSettings: [
                .headerSearchPath(".")
            ]
        ),
        .target(
            name: "TOML",
            dependencies: ["CTomlPlusPlus"],
            swiftSettings: [
                .interoperabilityMode(.Cxx)
            ]
        ),
        .testTarget(
            name: "TOMLTests",
            dependencies: ["TOML"],
            swiftSettings: [
                .interoperabilityMode(.Cxx)
            ]
        ),
    ],
    cxxLanguageStandard: .cxx17
)
