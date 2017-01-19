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
    
    public let host        : String
    public let username    : String
    public let password    : String
    public let port        : Int
    public let url         : String
    
    public init?(withService service: Service) {
    
        guard let credentials = service.credentials,
              let host      = credentials["host"] as? String,
              let username  = credentials["username"] as? String,
              let password  = credentials["password"] as? String,
              let port      = credentials["port"] as? Int,
              let url       = credentials["url"] as? String else {
            return nil
        }
        
        self.host     = host
        self.username = username
        self.password = password
        self.port     = port
        self.url      = url
        
        super.init(name:       service.name,
                   label:       service.label,
                   plan:        service.plan,
                   tags:        service.tags,
                   credentials: service.credentials)

    }
}

public class MongoDBService: Service {
    
    public let user        : String
    public let password    : String
    public let port        : Int
    public let uri         : String
    
    public init?(withService service: Service) {
        
        guard let credentials = service.credentials,
            let user        = credentials["user"] as? String,
            let password    = credentials["password"] as? String,
            let port        = credentials["port"] as? Int,
            let uri         = credentials["uri"] as? String else {
                return nil
        }
        
        self.user       = user
        self.password   = password
        self.port       = port
        self.uri        = uri
        
        super.init(name:        service.name,
                   label:       service.label,
                   plan:        service.plan,
                   tags:        service.tags,
                   credentials: service.credentials)

    }
}


public class RedisService: Service {
    
    public let host        : String
    public let password    : String
    public let port        : Int

    public init?(withService service: Service) {
        
        guard let credentials = service.credentials,
              let uri       = credentials["uri"] as? String,
              let url       = URL(string: uri),
              let host      = url.host,
              let password  = url.password,
              let port      = url.port else {
            return nil
        }

        self.host     = host
        self.password = password
        self.port     = port
        
        super.init(name:        service.name,
                   label:       service.label,
                   plan:        service.plan,
                   tags:        service.tags,
                   credentials: service.credentials)
    }
}

public class PostgreSQLService: Service {
    
    public let publicHostname   : String
    public let password         : String
    public let username         : String
    
    public init?(withService service: Service) {
        
        guard let credentials = service.credentials,
            let publicHostname = credentials["public_hostname"] as? String,
            let username        = credentials["username"] as? String,
            let password        = credentials["password"] as? String else {
                return nil
        }
        
        self.publicHostname     = publicHostname
        self.username           = username
        self.password           = password
        
        super.init(name:        service.name,
                   label:       service.label,
                   plan:        service.plan,
                   tags:        service.tags,
                   credentials: service.credentials)

    }
}
