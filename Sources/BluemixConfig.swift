import SwiftConfiguration

import CloudFoundryEnv

/**
 Cloudant, MongoDB, Redis, PostgreSQL
 */

extension ConfigurationManager {
    
    private func findService(name: String) throws -> Service? {
        
        let appEnv = try CloudFoundryEnv.getAppEnv(configManager: self)
        return appEnv.getService(spec: name)
        
    }
    
    public func getCloudantService(name: String) throws -> CloudantService? {
        
        if let service = try findService(name: name) {
            return CloudantService(withService: service)
        } else {
            return nil
        }
        
        
    }
    
    public func getRedisService(name: String) throws -> RedisService? {
        
        if let service = try findService(name: name) {
            return RedisService(withService: service)
        } else {
            return nil
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
