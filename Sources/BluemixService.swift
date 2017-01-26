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
    
    public let host        : String
    public let username    : String
    public let password    : String
    public let port        : Int
    public let certificate : String
    
    public init?(withService service: Service) {
        
        guard let credentials = service.credentials else {
            print("Service credentials were nil.")
            return nil
        }
        
        // Use SSL uri if available
        let initialURI = credentials["uri"] as? String ?? ""
        let uris = initialURI.components(separatedBy: ",")
        let filtered  = uris.filter({ $0.contains("ssl=true") })
        var uriValue: String?
        if filtered.count == 1, let dbInfo = filtered.first,
            var credentialInfo = uris.first,
            let atRange = credentialInfo.range(of: "@") {
            // substitute non-ssl hostname:port with correct hostname:port
            credentialInfo.removeSubrange(atRange.upperBound..<credentialInfo.endIndex)
            uriValue = credentialInfo + dbInfo
        } else {
            uriValue = uris.first
        }
        
        guard let stringURL = uriValue, stringURL.characters.count > 0,
            let url         = URL(string: stringURL),
            let host        = url.host,
            let username    = url.user,
            let password    = url.password,
            let port        = url.port,
            let certificate = credentials["ca_certificate_base64"] as? String else {
                return nil
        }
        
        self.host        = host
        self.username    = username
        self.password    = password
        self.port        = port
        self.certificate = certificate
        
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
    
    public let host             : String
    public let port             : Int
    public let username         : String
    public let password         : String
    
    public init?(withService service: Service) {
        
        guard let credentials   = service.credentials,
              let uri           = credentials["uri"] as? String,
              let url           = URL(string: uri),
              let host          = url.host,
              let port          = url.port,
              let username      = url.user,
              let password      = url.password else {
                return nil
        }
        
        self.host               = host
        self.port               = port
        self.username           = username
        self.password           = password
        
        super.init(name:        service.name,
                   label:       service.label,
                   plan:        service.plan,
                   tags:        service.tags,
                   credentials: service.credentials)

    }
}

public class MySQLService: Service {
    
    public let database         : String
    public let host             : String
    public let username         : String
    public let password         : String
    public let port             : Int
    
    public init?(withService service: Service) {

        guard let credentials = service.credentials,
            let database   = credentials["name"] as? String,
            let host       = credentials["hostname"] as? String,
            let username   = credentials["username"] as? String,
            let password   = credentials["password"] as? String,
            let stringPort = credentials["port"] as? String,
            let port       = Int(stringPort) else {
                return nil
        }

        self.database = database
        self.host = host
        self.username = username
        self.password = password
        self.port = port
        
        super.init(name:        service.name,
                   label:       service.label,
                   plan:        service.plan,
                   tags:        service.tags,
                   credentials: service.credentials)
    }
    
}

public class DB2Service: Service {
    
    public let database     : String
    public let host         : String
    public let port         : Int
    public let uid          : String
    public let pwd          : String
    
    public init?(withService service: Service) {
        
        guard let credentials = service.credentials,
            let database = credentials["db"] as? String,
            let host = credentials["host"] as? String,
            let port = credentials["port"] as? Int,
            let uid = credentials["username"] as? String,
            let pwd = credentials["password"] as? String else {
            return nil
        }
        
        self.database = database
        self.host = host
        self.port = port
        self.uid = uid
        self.pwd = pwd
        
        super.init(name:        service.name,
                   label:       service.label,
                   plan:        service.plan,
                   tags:        service.tags,
                   credentials: service.credentials)
        
    }
    
}
