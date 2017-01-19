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
        
        guard let credentials = credentials, let host = credentials["host"] as? String,
              let username = credentials["username"] as? String,
              let password = credentials["password"] as? String,
              let port = credentials["port"] as? Int,
              let url = credentials["url"] as? String else {
            return nil
        }
        
        self.host     = host
        self.username = username
        self.password = password
        self.port     = port
        self.url      = url
        
    }
}

public class RedisService: Service {
    
    public var host        : String = ""
    public var password    : String = ""
    public var port        : Int = 0

    
    public init?(withService service: Service) {
        
        super.init(name:        service.name,
                   label:       service.label,
                   plan:        service.plan,
                   tags:        service.tags,
                   credentials: service.credentials)
        
        guard let credentials = credentials,
              let uri = credentials["uri"] as? String,
              let url = URL(string: uri),
              let host = url.host,
              let password = url.password,
              let port = url.port else {
            return nil
        }

        self.host     = host
        self.password = password
        self.port     = port
        
    }
}
