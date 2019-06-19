// swift-tools-version:4.2

import PackageDescription

let package = Package(
  name: "Hub",
  products: [
    .library(
      name: "Hub",
      targets: ["Hub"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/oleander/logger-swift.git", .branch("master")),

    .package(url: "https://github.com/JustHTTP/Just", from: "0.7.1"),
    .package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", from: "5.0.0"),
    .package(url: "https://github.com/tadija/AEXML.git", from: "4.1.0"),
    .package(url: "https://github.com/tid-kijyun/Kanna.git", from: "5.0.0"),

    .package(url: "https://github.com/Quick/Nimble.git", from: "8.0.2"),
    .package(url: "https://github.com/Quick/Quick.git", from: "2.1.0")
  ],
  targets: [
    .target(
      name: "Hub",
      dependencies: [
        "Just",
        "SwiftyJSON",
        "AEXML",
        "Kanna",
        "Logger"
      ]
    ),
    .testTarget(
      name: "HubTests",
      dependencies: ["Quick", "Nimble", "Hub"]
    )
  ],
  swiftLanguageVersions: [.v4_2]
)
