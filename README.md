# Hub

Hub is a client-side HTTP library written in Swift

## Example

``` swift
import Hub

let session = Hub(
  host: URL("https://api.example.com"),
  headers: [
    "Accept": "application/json",
    "Content-Type": "application/json; charset=utf-8",
    "Cache-Control": "max-age=0"
  ],
  cachePolicy: .returnCacheDataElseLoad
)

print(try session.get(path: "/hello").json())
```

## Install

``` swift
// swift-tools-version: 4.2
import PackageDescription

let package = Package(
  name: "YOUR_PROJECT_NAME",
  dependencies: [
    .package(url: "https://github.com/oleander/hub-swift.git", .branch("master")),
  ]
)
```
