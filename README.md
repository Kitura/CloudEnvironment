# BluemixConfig

Extensions to the SwiftConfiguration library to simplify loading Bluemix services.

Currently supports Cloudant, Redis, PostgreSQL, MongoDB, MySQL, and DB2.

## Basic Usage:

```swift
let manager = ConfigurationManager()

do {
  try manager.load(.EnvironmentVariables)
         .load(file: "config.json")
  
  let cloudantService = try manager.getCloudantService(name: "MyCloudantDB")
} catch {

}
```
