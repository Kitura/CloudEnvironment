/*
 * Copyright IBM Corporation 2017
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Configuration
import CloudFoundryEnv

/**
 Cloudant, MongoDB, Redis, PostgreSQL
 */

public enum ConfigurationManagerError: Error {
    case noServiceWithName(String)
}

extension ConfigurationManager {

    public func getCloudantService(name: String) throws -> CloudantService {

        if let service = getService(spec: name),
            let cloudantService = CloudantService(withService: service) {
                return cloudantService
        } else {
            throw ConfigurationManagerError.noServiceWithName(name)
        }
    }

    public func getMongoDBService(name: String) throws -> MongoDBService {

        if let service = getService(spec: name),
            let mongoDBService = MongoDBService(withService: service) {
            return mongoDBService
        } else {
            throw ConfigurationManagerError.noServiceWithName(name)
        }
    }

    public func getRedisService(name: String) throws -> RedisService {

        if let service = getService(spec: name),
            let redisService = RedisService(withService: service) {
                return redisService
        } else {
            throw ConfigurationManagerError.noServiceWithName(name)
        }
    }

    public func getObjectStorageService(name: String) throws -> ObjectStorageService {

        if let service = getService(spec: name),
            let objStrService = ObjectStorageService(withService: service) {
            return objStrService
        } else {
            throw ConfigurationManagerError.noServiceWithName(name)
        }
    }

    public func getPostgreSQLService(name: String) throws -> PostgreSQLService {

        if let service = getService(spec: name),
            let postgreSQLService = PostgreSQLService(withService: service) {
            return postgreSQLService
        } else {
            throw ConfigurationManagerError.noServiceWithName(name)
        }
    }

    public func getMySQLService(name: String) throws -> MySQLService {

        if let service = getService(spec: name),
            let mySQLService = MySQLService(withService: service) {
            return mySQLService
        } else {
            throw ConfigurationManagerError.noServiceWithName(name)
        }
    }

    public func getDB2Service(name: String) throws -> DB2Service {

        if let service = getService(spec: name),
            let myDB2Service = DB2Service(withService: service) {
            return myDB2Service
        } else {
            throw ConfigurationManagerError.noServiceWithName(name)
        }
    }

    public func getAlertNotificationService(name: String) throws -> AlertNotificationService {

        if let service = getService(spec: name),
            let alertNotificationService = AlertNotificationService(withService: service) {
            return alertNotificationService
        } else {
            throw ConfigurationManagerError.noServiceWithName(name)
        }
    }

    public func getAutoScalingService(name: String) throws -> AutoScalingService {

        if let service = getService(spec: name),
            let autoScalingService = AutoScalingService(withService: service) {
            return autoScalingService
        } else {
            throw ConfigurationManagerError.noServiceWithName(name)
        }
    }

}
