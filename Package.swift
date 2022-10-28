// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "NetworkingPlus",
  platforms: [
    .iOS(.v15),
    .macOS(.v10_15),
    .watchOS(.v6),
    .tvOS(.v13),
  ],
  products: [
    .library(
      name: "APIClient",
      targets: ["APIClient"]
    ),
  ],
  dependencies: [
    .package(
      url: "git@github.com:pointfreeco/swift-composable-architecture.git", .upToNextMinor(from: "0.44.1")
    ),
    .package(
      url: "https://github.com/pointfreeco/swift-snapshot-testing",
      from: "1.9.0"
    ),
  ],
  targets: [
    .target(
      name: "APIClient",
      dependencies: [
        .product(name: "Dependencies", package: "swift-composable-architecture")
      ]
    ),
    .testTarget(
      name: "APIClientTests",
      dependencies: [
        "APIClient",
        .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
      ],
      exclude: ["__Snapshots__"]
    ),
  ]
)
