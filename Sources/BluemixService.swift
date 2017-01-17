import Foundation

import CloudFoundryEnv

public enum BluemixServiceType {
    case cloudant
    case mongodb
    case redis
    case postgresql
    case other
}

public class CloudantService: Service {
    
    public var host        : String = ""
    public var username    : String = ""
    public var password    : String = ""
    public var port        : Int = 0
    public var url         : String = ""
    

    public init?(withService service: Service) {
    
        super.init(name:       service.name,
                  label:       service.label,
                  plan:        service.plan,
                  tags:        service.tags,
                  credentials: service.credentials)
        
        guard let credentials = credentials else {
            return nil
        }
        
        host     = (credentials["host"] as? String)!
        username = (credentials["username"] as? String)!
        password = (credentials["password"] as? String)!
        port     = (credentials["port"] as? Int)!
        url      = (credentials["url"] as? String)!
        
    }
}

public class RedisService: Service {
    
    public var host        : String = ""
    public var username    : String = ""
    public var password    : String = ""
    public var port        : Int = 0
    public var url         : String = ""
    
    
    public init?(withService service: Service) {
        
        super.init(name:        service.name,
                   label:       service.label,
                   plan:        service.plan,
                   tags:        service.tags,
                   credentials: service.credentials)
        
        guard let credentials = credentials else {
            return nil
        }
        
        host     = (credentials["host"] as? String)!
        username = (credentials["username"] as? String)!
        password = (credentials["password"] as? String)!
        port     = (credentials["port"] as? Int)!
        url      = (credentials["url"] as? String)!
        
    }
}
