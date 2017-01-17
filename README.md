# BluemixConfig

Extensions to the SwiftConfiguration library to simplify loading Bluemix services.

Currently supports Cloudant, Redis, PostgreSQL, and MongoDB.

## Basic Usage:

```swift
let manager = ConfigurationManager()

do {
  manager.load(.environmentVariables)
         .load(file: "config.json")
  
  let cloudantService = manager.getCloudantService(name: "MyCloudantDB")
} catch {

}
```
