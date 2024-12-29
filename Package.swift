// swift-tools-version: 6.0
import PackageDescription

let package = Package(
  name: "AramaKit",
  platforms: [
    .iOS(.v16),
    .macOS(.v13),
    .visionOS(.v1),
  ],
  products: [
    .library(
      name: "AramaKit",
      targets: ["AramaKit"])
  ],
  dependencies: [],
  targets: [
    .target(
      name: "AramaKit",
      dependencies: []),
    .testTarget(
      name: "AramaKitTests",
      dependencies: ["AramaKit"]),
  ]
)
