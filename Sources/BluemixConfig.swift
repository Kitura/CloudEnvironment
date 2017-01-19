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



import SwiftConfiguration

import CloudFoundryEnv

/**
 Cloudant, MongoDB, Redis, PostgreSQL
 */

public enum ConfigurationManagerError: Error {
    case noServiceWithName(String)
}

extension ConfigurationManager {
    
    private func findService(name: String) throws -> Service? {
        
        let appEnv = try CloudFoundryEnv.getAppEnv(configManager: self)
        return appEnv.getService(spec: name)
        
    }
    
    public func getCloudantService(name: String) throws -> CloudantService {
        
        if let service = try findService(name: name),
            let cloudantService = CloudantService(withService: service) {
                return cloudantService
        } else {
            throw ConfigurationManagerError.noServiceWithName(name)
        }
        
        
    }
    
    public func getMongoDBService(name: String) throws -> MongoDBService {
        
        if let service = try findService(name: name),
            let mongoDBService = MongoDBService(withService: service) {
            return mongoDBService
        } else {
            throw ConfigurationManagerError.noServiceWithName(name)
        }
        
        
    }
    
    public func getRedisService(name: String) throws -> RedisService {
        
        if let service = try findService(name: name),
            let redisService = RedisService(withService: service) {
                return redisService
        } else {
            throw ConfigurationManagerError.noServiceWithName(name)
        }

    }
    
    public func getPostgreSQLService(name: String) throws -> PostgreSQLService {
        
        if let service = try findService(name: name),
            let postgreSQLService = PostgreSQLService(withService: service) {
            return postgreSQLService
        } else {
            throw ConfigurationManagerError.noServiceWithName(name)
        }
        
        
    }
    
    public var applicationPort: Int {
    
        if let port = try? CloudFoundryEnv.getAppEnv().port {
            return port
        } else {
            return 8090     
        }
    
    }
}


extension CloudFoundryEnv {
    
    public static func getAppEnv(configManager: ConfigurationManager) throws -> AppEnv {
    
        let servs = configManager["VCAP_SERVICES"]

        let app = configManager["VCAP_APPLICATION"]
        var vcap: [String:Any] = [:]
        
        vcap["application"] = app
        vcap["services"] = servs
        var config: [String:Any] = [:]
        config["vcap"] = vcap
        return try AppEnv(options: config)
    }
    
}
