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
    
    public func getRedisService(name: String) throws -> RedisService {
        
        if let service = try findService(name: name),
            let redisService = RedisService(withService: service) {
                return redisService
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
