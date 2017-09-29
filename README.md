[![Build Status](https://travis-ci.org/IBM-Swift/CloudEnvironment.svg?branch=master)](https://travis-ci.org/IBM-Swift/CloudEnvironment)
![macOS](https://img.shields.io/badge/os-macOS-green.svg?style=flat)
![Linux](https://img.shields.io/badge/os-linux-green.svg?style=flat)
[![codecov](https://codecov.io/gh/IBM-Swift/CloudEnvironment/branch/master/graph/badge.svg)](https://codecov.io/gh/IBM-Swift/CloudEnvironment)

# CloudEnvironment
CloudEnvironment (formerly known as CloudConfiguration) is a convenience Swift package for accessing environment variables mapped to JSON objects from various Cloud computing environments, such as, but not limited to, Cloud Foundry and Kubernetes. For example, to obtain the credentials for accessing a Cloudant database, you need to parse the `VCAP_SERVICES` environment variable when running in Cloud Foundry, while to obtain the same credentials when running in Kubernetes, you may need to parse an environment variable named `CLOUDANT_CREDENTIALS`. In other words, the path for obtaining certain environment values may differ from one cloud environment to another. By leveraging this package, you can make your Swift application environment-agnostic when it comes to obtaining such values. Using CloudEnvironment allows you to abstract these low-level details from your application's source code.

## Swift version
The latest version of CloudEnvironment works with the `3.1.1` version of the Swift binaries. You can download this version of the Swift binaries by following this [link](https://swift.org/download/#snapshots).

## Abstraction and supported search pattern types
This package allows you to define a lookup key that your Swift application can leverage for searching its corresponding value. This abstraction decouples your application from the actual name used for the environment variable you are looking for. For example, if you created a Cloudant service named `my-awesome-cloudant-db`, you don't have to use this name as the key in your Swift code to obtain its credentials. Instead, you can define a lookup key, say `cloudant-credentials` and mapped it to the actual service name, `my-awesome-cloudant-db`.

This library also allows you to define an array of search patterns for looking up a JSON object mapped to environment variables, such as service credentials. Each element in the search patterns array will be *executed* until the variable is found. CloudEnvironment supports searching for values using the following three search pattern types:

- `cloudfoundry` - Allows to search for a value in Cloud Foundry's services environment variable (i.e. `VCAP_SERVICES`).
- `env` - Allows to search for a value mapped to an environment variable.
- `file` - Allows to search for a value in a JSON file.

You specify lookup keys and search patterns in a file named `mappings.json`. This file must exist in a `config` folder under the root folder of your Swift project. The following shows an example of a `mappings.json` file:

```javascript
{
    "cloudant-credentials": {
        "searchPatterns": [
            "cloudfoundry:my-awesome-cloudant-db",
            "env:my_awesome_cloudant_db_credentials",
            "file:localdev/my-awesome-cloudant-db-credentials.json"
        ]
    },
    "object-storage-credentials": {
        "searchPatterns": [
            "cloudfoundry:my-awesome-object-storage",
            "env:my_awesome_object_storage_credentials",
            "file:localdev/my-awesome-object-storage-credentials.json"
        ]
    }
}
```

In the example above, `cloudant-credentials` and `object-storage-credentials` are the lookup keys your Swift application should use to look up the corresponding credentials. Please note that the path next to the `file` search pattern must be relative to the root folder of your Swift application.

## Usage
To leverage the CloudEnvironment package in your Swift application, you should specify a dependency for it in your `Package.swift` file:

```swift
import PackageDescription

let package = Package(
   name: "MyAwesomeSwiftProject",

   ...

   dependencies: [
       .Package(url: "https://github.com/IBM-Swift/CloudEnvironment.git", majorVersion: 4),

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
// cloudantCredentials.username, cloudantCredentials.password, cloudantCredentials.url, etc.
let objStorageCredentials = cloudEnv.getObjectStorageCredentials(name: "object-storage-credentials")
// objStorageCredentials.username, objStorageCredentials.password, objStorageCredentials.projectID, etc.
...

let service1Credentials = cloudEnv.getDictionary("service1-credentials")
let service1CredentialsStr = cloudEnv.getString("service1-credentials")

...

// Get a default PORT and URL
let port = cloudEnv.port
let url = cloudEnv.url

...
```

This library simplifies obtaining service credentials, as shown above. For details on the different elements (e.g `username`, `password`, `url`, etc.) that make up a credentials set and accessor methods for service credentials, check out the [docs](docs/Classes) directory, which contains [Jazzy](https://github.com/Realm/jazzy) generated documentation.

Following the above approach your application can be implemented in a runtime-environment agnostic way, abstracting differences in environment variable management introduced by different Cloud computing environments.

## Supported services
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

If you don't see listed above the service you intend to use in your Swift application, you can leverage the generic `getDictionary(name: String)` method to get the corresponding credentials:

```swift
import CloudEnvironment

...

let cloudEnv = CloudEnv()

...

if let credentials: [String:Any]? = cloudEnv.getDictionary(name: "service1-credentials") {
  // You can now get the corresponding values from dictionary
}

...
```
