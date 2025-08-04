// swift-tools-version: 5.10

// © 2024—2025 John Gary Pusey (see LICENSE.md)

import PackageDescription

let package = Package(name: "XestiSexp",
                      platforms: [.iOS(.v16),
                                  .macOS(.v14)],
                      products: [.library(name: "XestiSexp",
                                          targets: ["XestiSexp"])],
                      dependencies: [.package(url: "https://github.com/eBardX/XestiMath.git",
                                              from: "2.0.0"),
                                     .package(url: "https://github.com/eBardX/XestiTools.git",
                                              from: "4.0.0")],
                      targets: [.target(name: "XestiSexp",
                                        dependencies: [.product(name: "XestiMath",
                                                                package: "XestiMath"),
                                                       .product(name: "XestiTools",
                                                                package: "XestiTools")]),
                                .testTarget(name: "XestiSexpTests",
                                            dependencies: [.product(name: "XestiMath",
                                                                    package: "XestiMath"),
                                                           .target(name: "XestiSexp")])],
                      swiftLanguageVersions: [.v5])

let swiftSettings: [SwiftSetting] = [.enableUpcomingFeature("BareSlashRegexLiterals"),
                                     .enableUpcomingFeature("ConciseMagicFile"),
                                     .enableUpcomingFeature("ExistentialAny"),
                                     .enableUpcomingFeature("ForwardTrailingClosures"),
                                     .enableUpcomingFeature("ImplicitOpenExistentials")]

for target in package.targets {
    var settings = target.swiftSettings ?? []

    settings.append(contentsOf: swiftSettings)

    target.swiftSettings = settings
}
