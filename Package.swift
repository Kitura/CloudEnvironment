import PackageDescription

let package = Package(
    name: "BluemixConfig",
    dependencies: [
        .Package(url: "git@github.ibm.com:IBM-Swift/swift-configuration.git", majorVersion: 0)
    ]
)
