# BluemixConfig

Extensions to the SwiftConfiguration library to simplify loading Bluemix services.

## Basic Usage:

let manager = ConfigurationManager()

do {
  manager.load(.environmentVariables)
         .load(file: "config.json")
  
  let cloudantService = manager.getCloudantService(name: "MyCloudantDB")
} catch {

}
