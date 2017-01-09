import SwiftConfiguration

let cloudantConfigKey = "Bluemix:services:cloudant"

extension ConfigurationManager {

    
    private func loadCloudantConfig () {
        
        let username = self.getValue(for: "VCAP_SERVICES:cloudantNoSQLDB:credentials:username") as? String
        let password = self.getValue(for: "VCAP_SERVICES:cloudantNoSQLDB:credentials:password") as? String
        let host     = self.getValue(for: "VCAP_SERVICES:cloudantNoSQLDB:credentials:host") as? String
        let uri      = self.getValue(for: "VCAP_SERVICES:cloudantNoSQLDB:credentials:url") as? String
        let port     = self.getValue(for: "VCAP_SERVICES:cloudantNoSQLDB:credentials:port") as? Int
        
        var service = BluemixService()
        service.username = username
        service.password = password
        service.host = host
        service.uri = uri
        service.port = port
        
        self.setValue(for: cloudantConfigKey, as: service)
        
    }

    func getCloudantConfig() -> BluemixService? {
        return getValue(for: cloudantConfigKey) as? BluemixService
    }
    
    @discardableResult
    func loadBluemixServices() -> ConfigurationManager {
        
        self.loadEnvironmentVariables()
        
        loadCloudantConfig()
        
        return self
        
    }
    
    @discardableResult
    func loadBluemixService(type: BluemixServiceType) -> ConfigurationManager {
        
        switch type {
        case .cloudant: loadCloudantConfig()
        default: break
        }
        
        return self
    }
    
}
