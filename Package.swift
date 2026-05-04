// swift-tools-version: 6.2

// © 2024–2026 John Gary Pusey (see LICENSE.md)

import PackageDescription

let swiftSettings: [SwiftSetting] = [.defaultIsolation(nil),
                                     .enableUpcomingFeature("ExistentialAny"),
                                     .enableUpcomingFeature("ImmutableWeakCaptures"),
                                     .enableUpcomingFeature("InferIsolatedConformances"),
                                     .enableUpcomingFeature("InternalImportsByDefault"),
                                     .enableUpcomingFeature("MemberImportVisibility"),
                                     .enableUpcomingFeature("NonisolatedNonsendingByDefault")]

let package = Package(name: "XestiSexp",
                      platforms: [.iOS(.v16),
                                  .macOS(.v14)],
                      products: [.library(name: "XestiSexp",
                                          targets: ["XestiSexp"])],
                      dependencies: [.package(url: "https://github.com/eBardX/XestiNumbers.git",
                                              .upToNextMajor(from: "1.0.0")),
                                     .package(url: "https://github.com/eBardX/XestiTokens.git",
                                              .upToNextMajor(from: "1.1.0")),
                                     .package(url: "https://github.com/eBardX/XestiTools.git",
                                              .upToNextMajor(from: "7.2.0"))],
                      targets: [.target(name: "XestiSexp",
                                        dependencies: [.product(name: "XestiNumbers",
                                                                package: "XestiNumbers"),
                                                       .product(name: "XestiTokens",
                                                                package: "XestiTokens"),
                                                       .product(name: "XestiTools",
                                                                package: "XestiTools")],
                                        swiftSettings: swiftSettings),
                                .testTarget(name: "XestiSexpTests",
                                            dependencies: [.product(name: "XestiNumbers",
                                                                    package: "XestiNumbers"),
                                                           .target(name: "XestiSexp")],
                                        swiftSettings: swiftSettings)],
                      swiftLanguageModes: [.v6])
