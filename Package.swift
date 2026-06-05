// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "DynamicNotch",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "DynamicNotch", targets: ["DynamicNotch"])
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "DynamicNotch",
            dependencies: [],
            path: "DynamicNotch",
            exclude: [
                "Info.plist",
                "DynamicNotch.entitlements"
            ],
            resources: [
                .process("Resources/Assets.xcassets"),
                .process("Resources/Localization/Localizable.xcstrings")
            ]
        )
    ]
)
