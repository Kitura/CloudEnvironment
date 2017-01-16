import SwiftConfiguration

let cloudantConfigKey = "Bluemix:services:cloudant"

/**
 Cloudant, MongoDB, Redis, PostgreSQL
 */

extension ConfigurationManager {

    private func loadCloudantConfig () -> BluemixService? {
        
        if let username = self["VCAP_SERVICES:cloudantNoSQLDB:0:credentials:username"] as? String,
            let password = self["VCAP_SERVICES:cloudantNoSQLDB:0:credentials:password"] as? String,
            let host     = self["VCAP_SERVICES:cloudantNoSQLDB:0:credentials:host"] as? String,
            let url      = self["VCAP_SERVICES:cloudantNoSQLDB:0:credentials:url"] as? String,
            let port     = self["VCAP_SERVICES:cloudantNoSQLDB:0:credentials:port"] as? Int,
            let label    = self["VCAP_SERVICES:cloudantNoSQLDB:0:label"] as? String,
            let name     = self["VCAP_SERVICES:cloudantNoSQLDB:0:name"] as? String,
            let tags     = self["VCAP_SERVICES:cloudantNoSQLDB:0:tags"] as? [String]
        {
            
            return CloudantService(host: host, username: username, password: password, port: port, url: url, label: label, name: name, tags: tags)
        }
        
        return nil
        
    }
    
    public func getService(type: BluemixServiceType) -> BluemixService? {
        
        switch type {
        case .cloudant:
            return loadCloudantConfig()
        default:
            return nil
        }
        
    }
    
}
