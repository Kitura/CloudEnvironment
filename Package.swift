import PackageDescription

let package = Package(
    name: "CloudConfiguration",
    dependencies: [
        .Package(url: "https://github.com/IBM-Swift/LoggerAPI.git", majorVersion: 1),
        .Package(url: "https://github.com/IBM-Swift/Swift-cfenv.git", majorVersion: 4)
    ]
)
