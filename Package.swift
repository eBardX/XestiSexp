// swift-tools-version: 6.2

// © 2024—2025 John Gary Pusey (see LICENSE.md)

import PackageDescription

let package = Package(name: "XestiSexp",
                      platforms: [.iOS(.v16),
                                  .macOS(.v14)],
                      products: [.library(name: "XestiSexp",
                                          targets: ["XestiSexp"])],
                      dependencies: [.package(url: "https://github.com/eBardX/XestiMath.git",
                                              .upToNextMajor(from: "3.0.0")),
                                     .package(url: "https://github.com/eBardX/XestiTools.git",
                                              .upToNextMajor(from: "6.0.0"))],
                      targets: [.target(name: "XestiSexp",
                                        dependencies: [.product(name: "XestiMath",
                                                                package: "XestiMath"),
                                                       .product(name: "XestiTools",
                                                                package: "XestiTools")]),
                                .testTarget(name: "XestiSexpTests",
                                            dependencies: [.product(name: "XestiMath",
                                                                    package: "XestiMath"),
                                                           .target(name: "XestiSexp")])],
                      swiftLanguageModes: [.v6])

let swiftSettings: [SwiftSetting] = [.defaultIsolation(nil),
                                     .enableUpcomingFeature("ExistentialAny")]

for target in package.targets {
    var settings = target.swiftSettings ?? []

    settings.append(contentsOf: swiftSettings)

    target.swiftSettings = settings
}
