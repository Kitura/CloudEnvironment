<p align="center">
    <a href="http://kitura.io/">
        <img src="https://raw.githubusercontent.com/IBM-Swift/Kitura/master/Sources/Kitura/resources/kitura-bird.svg?sanitize=true" height="100" alt="Kitura">
    </a>
</p>

<p align="center">
<a href="https://ibm-swift.github.io/CloudEnvironment/index.html">
<img src="https://img.shields.io/badge/apidoc-CloudEnvironment-1FBCE4.svg?style=flat" alt="APIDoc">
</a>
    <a href="https://travis-ci.org/IBM-Swift/CloudEnvironment">
    <img src="https://travis-ci.org/IBM-Swift/CloudEnvironment.svg?branch=master" alt="Build Status - Master">
    </a>
    <img src="https://img.shields.io/badge/os-macOS-green.svg?style=flat" alt="macOS">
    <img src="https://img.shields.io/badge/os-linux-green.svg?style=flat" alt="Linux">
    <img src="https://img.shields.io/badge/license-Apache2-blue.svg?style=flat" alt="Apache 2">
    <a href="http://swift-at-ibm-slack.mybluemix.net/">
    <img src="http://swift-at-ibm-slack.mybluemix.net/badge.svg" alt="Slack Status">
    </a>
</p>

# CloudEnvironment
CloudEnvironment (formerly known as CloudConfiguration) is a convenience Swift package for accessing environment variables mapped to JSON objects from various Cloud computing environments, such as, but not limited to, Cloud Foundry and Kubernetes.

For example, to obtain the credentials for accessing a Cloudant database, you need to parse the `VCAP_SERVICES` environment variable when running in Cloud Foundry, while to obtain the same credentials when running in Kubernetes, you may need to parse an environment variable named `CLOUDANT_CREDENTIALS`. In other words, the path for obtaining certain environment values may differ from one cloud environment to another. By leveraging this package, you can make your Swift application environment-agnostic when it comes to obtaining such values. Using CloudEnvironment allows you to abstract these low-level details from your application's source code.

## Swift version
The latest version of CloudEnvironment works with `4.0` and newer versions of the Swift binaries. You can download Swift binaries by following this [link](https://swift.org/download/#releases).

## Abstraction and supported search pattern types
This package allows you to define a lookup key that your Swift application can leverage when searching for its corresponding value. This abstraction decouples your application from the actual name used for the environment variable you are looking for. For example, if you created a Cloudant service named `my-awesome-cloudant-db`, you don't have to use this name as the key in your Swift code to obtain its credentials. Instead, you can define a lookup key, say `cloudant-credentials` and map it to the actual service name, `my-awesome-cloudant-db`.

This library also allows you to define an array of search patterns for looking up a JSON object which is mapped to an environment variable, such as service credentials. Each element in the search patterns array will be *executed* until the variable is found. CloudEnvironment supports searching for values using the following three search pattern types:

- `cloudfoundry` - Allows you to search for a value in Cloud Foundry's services environment variable (i.e. `VCAP_SERVICES`).
- `env` - Allows you to search for a value mapped to an environment variable.
- `file` - Allows you to search for a value in a JSON file.

You specify lookup keys and search patterns in a file named `mappings.json`. This file must exist in a `config` folder under the root folder of your Swift project. The following shows an example of a `mappings.json` file:

```javascript
{
    "cloudant-credentials": {
        "credentials": {
            "searchPatterns": [
                "cloudfoundry:my-awesome-cloudant-db",
                "env:my_awesome_cloudant_db_credentials",
                "file:localdev/my-awesome-cloudant-db-credentials.json"
            ]
        }
    },
    "object-storage-credentials": {
        "credentials": {
            "searchPatterns": [
                "cloudfoundry:my-awesome-object-storage",
                "env:my_awesome_object_storage_credentials",
                "file:localdev/my-awesome-object-storage-credentials.json"
            ]
        }
    }
}
```

In the example above, `cloudant-credentials` and `object-storage-credentials` are the lookup keys your Swift application should use to look up the corresponding credentials. Please note that the path next to the `file` search pattern must be relative to the root folder of your Swift application.

## Usage

#### Add dependencies

Add the `CloudEnvironment` package to the dependencies within your application’s `Package.swift` file. Substitute `"x.x.x"` with the latest `CloudEnvironment` [release](https://github.com/IBM-Swift/CloudEnvironment/releases).

```swift
.package(url: "https://github.com/IBM-Swift/CloudEnvironment.git", from: "x.x.x")
```

Add `CloudEnvironment` to your target's dependencies:

```swift
.target(name: "example", dependencies: ["CloudEnvironment"]),
```

 Once the `Package.swift` file of your application has been updated, import the `CloudEnvironment` modules and initialize an instance of `CloudEnvironment`:

```swift
import CloudEnvironment

let cloudEnv = CloudEnv()
```

Once you have a `cloudEnv` instance you can use it to query the credentials for one of the supported services, such as, Cloudant or ObjectStorage, as shown below this will return the credentials associated with that service:

```swift
let cloudantCredentials = cloudEnv.getCloudantCredentials(name: "cloudant-credentials")
// cloudantCredentials.username, cloudantCredentials.password, cloudantCredentials.url, etc.
let objStorageCredentials = cloudEnv.getObjectStorageCredentials(name: "object-storage-credentials")
// objStorageCredentials.username, objStorageCredentials.password, objStorageCredentials.projectID, etc.

let service1Credentials = cloudEnv.getDictionary("service1-credentials")
let service1CredentialsStr = cloudEnv.getString("service1-credentials")

// Get a default PORT and URL
let port = cloudEnv.port
let url = cloudEnv.url
```

This library simplifies obtaining service credentials, as shown above. For details on the different elements (e.g. `username`, `password`, `url`, etc.) that make up a credentials set and accessor methods for service credentials, check out the API reference documentation.

Following the above approach your application can be implemented in a runtime-environment agnostic way, abstracting differences in environment variable management introduced by different Cloud computing environments.

## Supported services
The following services are currently supported by this library. Therefore, you can obtain the service credentials for any of these services with minimum effort:
- [Alert Notification](https://cloud.ibm.com/catalog/services/alert-notification)
- [AppID](https://cloud.ibm.com/catalog/services/appID)
- [Auto-Scaling](https://cloud.ibm.com/catalog/services/auto-scaling)
- [Cloudant](https://cloud.ibm.com/catalog/services/cloudant)
- [Cloud Functions](https://cloud.ibm.com/openwhisk)
- [Db2](https://cloud.ibm.com/catalog/services/db2-on-cloud)
- [Hyper Protect DBaaS](https://cloud.ibm.com/catalog/services/hyper-protect-dbaas)
- [MongoDB](https://cloud.ibm.com/catalog/services/databases-for-mongodb)
- [MySQL](https://cloud.ibm.com/catalog/services/compose-for-mysql)
- [Natural Language Understanding](https://cloud.ibm.com/catalog/services/natural-language-understanding)
- [Object Storage](https://docs.openstack.org/swift/latest/)
- [PostgreSQL](https://cloud.ibm.com/catalog/services/databases-for-postgresql)
- [Push SDK](https://cloud.ibm.com/catalog/services/push-notifications)
- [Redis](https://cloud.ibm.com/catalog/services/databases-for-redis)
- [Watson Assistant](https://cloud.ibm.com/catalog/services/watson-assistant)
- [Weather Company Data](https://cloud.ibm.com/catalog/services/weather-company-data)

If you don't see listed above the service you intend to use in your Swift application, you can leverage the generic `getDictionary(name: String)` method to get the corresponding credentials:

```swift
import CloudEnvironment

let cloudEnv = CloudEnv()

if let credentials: [String:Any] = cloudEnv.getDictionary(name: "service1-credentials") {
  // You can now get the corresponding values from the dictionary
}
```

## API documentation

For more information visit our [API reference](http://ibm-swift.github.io/CloudEnvironment/).

## Community

We love to talk server-side Swift, and Kitura. Join our [Slack](http://swift-at-ibm-slack.mybluemix.net/) to meet the team!

## License

This library is licensed under Apache 2.0. Full license text is available in [LICENSE](https://github.com/IBM-Swift/CloudEnvironment/blob/master/LICENSE).
