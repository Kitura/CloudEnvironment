import PackageDescription

let package = Package(
    name: "SwiftConfiguration",
    dependencies: [
        .Package(url: "git@github.ibm.com:IBM-Swift/Configuration.git", majorVersion: 0),
        .Package(url: "https://github.com/IBM-Swift/Swift-cfenv.git", majorVersion: 2)
    ]
)
