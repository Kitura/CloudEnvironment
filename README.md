[![Build Status - Develop](https://travis-ci.org/IBM-Swift/CloudConfiguration.svg?branch=master)](https://travis-ci.org/IBM-Swift/CloudConfiguration)
![macOS](https://img.shields.io/badge/os-macOS-green.svg?style=flat)
![Linux](https://img.shields.io/badge/os-linux-green.svg?style=flat)

# CloudConfiguration

The write once, run anywhere configuration library. Designed to be a platform agnostic way to automatically
configuring connections to your hosting services.

## Platforms:

- Bluemix
- Heroku (future)
- Amazon AWS (future)

## Supported services:

- Cloudant
- Redis
- PostgreSQL
- MongoDB
- MySQL

## Basic Usage:

```swift
let manager = ConfigurationManager()

let mongoDBService = try manager.getMongoDBService()

mongoDBService.username
mongoDBService.password
mongoDBService.hostname
mongoDBService.port

```
