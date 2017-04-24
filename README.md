[![Build Status](https://travis-ci.org/IBM-Swift/CloudConfiguration.svg?branch=master)](https://travis-ci.org/IBM-Swift/CloudConfiguration)
![macOS](https://img.shields.io/badge/os-macOS-green.svg?style=flat)
![Linux](https://img.shields.io/badge/os-linux-green.svg?style=flat)

# CloudConfiguration

The write once, run anywhere configuration library. Designed to be a platform agnostic way to automatically configure connections to your hosting services.

## Platforms:

- Bluemix CloudFoundry

## Supported services:

- Alert Notification
- AppID
- Auto Scaling
- DB2
- Cloudant
- MongoDB
- MySQL
- Object Storage
- PostgreSQL
- Redis

## Usage:

```swift
let manager = ConfigurationManager().load(.environmentVariables)

let mongoDBService = try manager.getMongoDBService()

mongoDBService.username
mongoDBService.password
mongoDBService.hostname
mongoDBService.port
```
