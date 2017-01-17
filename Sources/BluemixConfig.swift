import SwiftConfiguration

import CloudFoundryEnv

/**
 Cloudant, MongoDB, Redis, PostgreSQL
 */

extension ConfigurationManager {
    
    
    public func getCloudantService(name: String) -> CloudantService {
        
        
        
    }
    
    public func getRedisService(name: String) -> RedisService {
        
    }
    
}


extension CloudFoundryEnv {
    
    public static func getAppEnv(configManager: ConfigurationManager) throws -> AppEnv {
        // Get services
        let servs = configManager["VCAP_SERVICES"]
        // Get app
        let app = configManager["VCAP_APPLICATION"]
        var vcap: [String:Any] = [:]
        vcap["application"] = app
        vcap["services"] = servs
        var config: [String:Any] = [:]
        config["vcap"] = vcap
        return try AppEnv(options: config)
    }
    
}
