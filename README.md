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

