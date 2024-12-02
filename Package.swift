// swift-tools-version:5.11

import PackageDescription

let swiftSettings: [SwiftSetting] = [.enableUpcomingFeature("BareSlashRegexLiterals"),
                                     .enableUpcomingFeature("ConciseMagicFile"),
                                     .enableUpcomingFeature("ExistentialAny"),
                                     .enableUpcomingFeature("ForwardTrailingClosures"),
                                     .enableUpcomingFeature("ImplicitOpenExistentials")]

let package = Package(name: "XestiSexp",
                      platforms: [.iOS(.v16),
                                  .macOS(.v13)],
                      products: [.library(name: "XestiSexp",
                                          targets: ["XestiSexp"])],
                      dependencies: [.package(url: "https://github.com/eBardX/XestiMath.git",
                                              from: "1.0.0"),
                                     .package(url: "https://github.com/eBardX/XestiTools.git",
                                              from: "3.4.0")],
                      targets: [.target(name: "XestiSexp",
                                        dependencies: [.product(name: "XestiMath",
                                        						package: "XestiMath"),
                                                       .product(name: "XestiTools",
                                                                package: "XestiTools")],
                                        swiftSettings: swiftSettings),
                                .testTarget(name: "XestiSexpTests",
                                            dependencies: [.product(name: "XestiMath",
                                                                    package: "XestiMath"),
                                                           .target(name: "XestiSexp")],
                                            swiftSettings: swiftSettings)],
                      swiftLanguageVersions: [.version("5")])
