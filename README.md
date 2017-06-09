[![Build Status](https://travis-ci.org/IBM-Swift/CloudConfiguration.svg?branch=master)](https://travis-ci.org/IBM-Swift/CloudConfiguration)
![macOS](https://img.shields.io/badge/os-macOS-green.svg?style=flat)
![Linux](https://img.shields.io/badge/os-linux-green.svg?style=flat)

# CloudConfiguration

A convenience Swift package for accessing Bluemix services.

## Platforms:

- [Bluemix CloudFoundry](https://console.ng.bluemix.net/catalog/)

## Supported services:

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

## Swift version
The latest version of CloudConfiguration works with the `3.1.1` version of the Swift binaries. You can download this version of the Swift binaries by following this [link](https://swift.org/download/#snapshots).

## Configuration
The latest version of CloudConfiguration relies on the [Configuration](https://github.com/IBM-Swift/Configuration) package to load and merge configuration data from multiple sources, such as environment variables or JSON files. CloudConfiguration also relies on [Swift-cfenv](https://github.com/IBM-Swift/Swift-cfenv), which provides structures and methods to parse Cloud Foundry-provided configuration variables, as well as providing default values when running locally. All of this information is available in an instance of `ConfigurationManager` from CloudConfiguration.

## Usage
To leverage the CloudConfiguration package in your Swift application, you should specify a dependency for it in your `Package.swift` file:

```swift
 import PackageDescription

 let package = Package(
     name: "MyAwesomeSwiftProject",

     ...

     dependencies: [
         .Package(url: "https://github.com/IBM-Swift/CloudConfiguration.git", majorVersion: 3),

         ...

     ])
 ```

 Once the Package.swift file of your application has been updated accordingly, you can import the `CloudFoundryEnv`, `Configuration`, and `CloudFoundryConfig` modules in your code to access:

```swift
 import Foundation
 import Configuration
 import CloudFoundryEnv

...

let cloudConfigFile: String = ...

let manager = ConfigurationManager().load(file: cloudConfigFile).load(.environmentVariables)

let credentials =  manager.getCloudantCredentials(name: "Starter-Cloudant")

// Use credentials for Cloudant to connect to service

...

credentials.username
credentials.password

...

```

The main purpose of this library is to simplify accessing the configuration values provided by Bluemix services, as this previous example shows with Cloudant.  For a list of the configuration values and accessor method for each service, check out the [docs](docs/Classes) directory, which contains [Jazzy](https://github.com/Realm/jazzy) generated documentation.
