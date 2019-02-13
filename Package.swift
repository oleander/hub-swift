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
    .package(url: "https://github.com/JustHTTP/Just", from: "0.6.0"),
    .package(url: "https://github.com/IBM-Swift/SwiftyJSON.git", .branch("swift42")),
    .package(url: "https://github.com/tadija/AEXML.git", from: "4.1.0"),
    .package(url: "https://github.com/tid-kijyun/Kanna.git", from: "4.0.2"),
    .package(url: "https://github.com/oleander/logger-swift.git", .branch("master")),
    .package(url: "https://github.com/Quick/Nimble.git", from: "7.0.2"),
    .package(url: "https://github.com/Quick/Quick.git", from: "1.2.0")
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
