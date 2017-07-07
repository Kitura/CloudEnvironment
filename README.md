[![Build Status](https://travis-ci.org/IBM-Swift/CloudConfiguration.svg?branch=develop)](https://travis-ci.org/IBM-Swift/CloudConfiguration)
![macOS](https://img.shields.io/badge/os-macOS-green.svg?style=flat)
![Linux](https://img.shields.io/badge/os-linux-green.svg?style=flat)

# CloudEnvironment
CloudEnvironment is a convenience Swift package for accessing environment variables from various Cloud computing environments, such as, but not limited to, Cloud Foundry and Kubernetes. By leveraging this package, you make your Swift application environment-agnostic when it comes to obtaining data from environment variables. For example, to obtain the credentials for accessing a Cloudant database, you would need to parse the `VCAP_SERVICES` environment variable when running in Cloud Foundry, while to obtain the same credentials when running in Kubernetes, you may need to parse an environment variable named `CLOUDANT_CREDENTIALS`. Using CloudEnvironment allows you to abstract these low-level details from your application's source code.

## Swift version
The latest version of CloudEnvironment works with the `3.1.1` version of the Swift binaries. You can download this version of the Swift binaries by following this [link](https://swift.org/download/#snapshots).

## Supported search patterns types
This package allows you to define an array of search patterns for looking up values, such as service credentials. Each element in a search patterns array will be *executed* until the variable is found. CloudEnvironment supports searching for values using three search pattern types:

- `cloudfoundry` - Allows to search for a value in Cloud Foundry's services environment variable.
- `env` - Allows to search for a value in an environment variable.
- `file` - Allows to search for a value in a JSON file.

You specify search patterns in a file named `mappings.json`. This file must exist in a `config` folder under the root folder of your Swift project. The following shows an example of a `mappings.json` file:

```javascript
{
    "cloudant-credentials": {
        "searchPatterns": [
            "cloudfoundry:my-awesome-cloudant-db",
            "env:my-awesome-cloudant-db-credentials",
            "file:localdev/my-awesome-cloudant-db-credentials.json"
        ]
    },
    "object-storage-credentials": {
        "searchPatterns": [
            "cloudfoundry:my-awesome-object-storage",
            "env:my-awesome-object-storage-credentials",
            "file:localdev/my-awesome-object-storage-credentials.json"
        ]
    }
}
```

In the example above, `cloudant-credentials` and `object-storage-credentials` are the keys your Swift application should use to look up the corresponding credentials. Please note that the paths next to the `file` search pattern must be relative to the root folder of your Swift application.

## Usage
To leverage the CloudEnvironment package in your Swift application, you should specify a dependency for it in your `Package.swift` file:

```swift
 import PackageDescription

 let package = Package(
     name: "MyAwesomeSwiftProject",

     ...

     dependencies: [
         .Package(url: "https://github.com/IBM-Swift/CloudEnvironment.git", majorVersion: 3),

         ...

     ])
 ```

 Once the `Package.swift` file of your application has been updated accordingly, you can import the `CloudEnvironment` modules in your code:

```swift
import CloudEnvironment

...

let cloudEnv = CloudEnv()

...

let cloudantCredentials = cloudEnv.getCloudantCredentials(name: "cloudant-credentials")
// cloudantCredentials.username, cloudantCredentials.password, etc.
let objStorageCredentials = cloudEnv.getObjectStorageCredentials(name: "object-storage-credentials")
// objStorageCredentials.username, objStorageCredentials.password, objStorageCredentials.projectID, etc.
...

let service1Credentials = cloudEnv.getDictionary("service1-credentials")
let service1CredentialsStr = cloudEnv.getString("service1-credentials")

...

```

This library simplifies obtaining service credentials, as shown above. For details on the different elements (e.g `username`, `password`, `host`, etc.) that make up a credentials set and accessor methods for service credentials, check out the [docs](docs/Classes) directory, which contains [Jazzy](https://github.com/Realm/jazzy) generated documentation.

Following the above approach your application can be implemented in a runtime-environment agnostic way, abstracting differences in environment variable management introduced by different Cloud computing environments.

## Supported services:
The following services are currently supported by this library. Therefore, you can obtain the service credentials for any of these services with minimum effort:
- [Alert Notification](https://console.ng.bluemix.net/catalog/services/ibm-alert-notification/)
- [AppID](https://console.ng.bluemix.net/catalog/services/app-id)
- [Auto Scaling](https://console.ng.bluemix.net/catalog/services/auto-scaling)
- [DB2](https://console.ng.bluemix.net/catalog/services/ibm-db2-on-cloud)
- [Cloudant](https://console.ng.bluemix.net/catalog/services/cloudant-nosql-db)
- [MongoDB](https://console.ng.bluemix.net/docs/services/MongoDB/index.html)
- [MySQL](https://console.ng.bluemix.net/catalog/services/compose-for-mysql/)
- [Natural Language Understanding](https://console.ng.bluemix.net/catalog/services/natural-language-understanding)
- [Object Storage](https://console.ng.bluemix.net/catalog/services/object-storage)
- [PostgreSQL](https://console.ng.bluemix.net/catalog/services/compose-for-postgresql/)
- [Push SDK](https://console.ng.bluemix.net/catalog/services/push-notifications)
- [Redis](https://console.ng.bluemix.net/catalog/services/redis-cloud)
- [Watson Conversation](https://console.ng.bluemix.net/catalog/services/conversation)
- [Weather Company Data](https://console.bluemix.net/catalog/services/weather-company-data)

## Configuration
It is worth mentioning that the latest version of CloudEnvironment relies on the [Configuration](https://github.com/IBM-Swift/Configuration) package to load configuration data from multiple sources, such as environment variables or JSON files. CloudEnvironment also relies on [Swift-cfenv](https://github.com/IBM-Swift/Swift-cfenv), which provides structures and methods for parsing Cloud Foundry-provided configuration variables, as well as providing default values when running locally.
