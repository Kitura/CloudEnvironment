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

/// Contains the configuration values for an Alert Notification service instance
public class AlertNotificationService: Service {

    public let url: String
    public let id: String
    public let password: String
    public let swaggerUI: String

    public init?(withService service: Service) {

        guard let credentials = service.credentials,
            let url = credentials["url"] as? String,
            let id = credentials["name"] as? String,
            let swaggerUI = credentials["swaggerui"] as? String,
            let password = credentials["password"] as? String else {
                return nil
        }

        self.url = url
        self.id = id
        self.password = password
        self.swaggerUI = swaggerUI

        super.init(name: service.name,
                   label: service.label,
                   plan: service.plan,
                   tags: service.tags,
                   credentials: service.credentials)
    }
}

/// Contains the configuration values for an AppID service instance
public class AppIDService: Service {

    public let clientId:       String
    public let oauthServerUrl: String
    public let profilesUrl:    String
    public let secret:         String
    public let tenantId:       String
    public let version:        Int

    public init?(withService service: Service) {

        guard let credentials = service.credentials,
            let clientId = credentials["clientId"] as? String,
            let oauthServerUrl = credentials["oauthServerUrl"] as? String,
            let profilesUrl = credentials["profilesUrl"] as? String,
            let secret = credentials["secret"] as? String,
            let tenantId = credentials["tenantId"] as? String,
            let version = credentials["version"] as? Int
            else {
                return nil
        }

        self.clientId = clientId
        self.oauthServerUrl = oauthServerUrl
        self.profilesUrl = profilesUrl
        self.secret = secret
        self.tenantId = tenantId
        self.version = version

        super.init(name:        service.name,
                   label:       service.label,
                   plan:        service.plan,
                   tags:        service.tags,
                   credentials: service.credentials)
    }
}

/// Contains the configuration values for an Auto Scaling service instance
public class AutoScalingService: Service {

    public let username: String
    public let password: String
    public let appID: String
    public let url: String
    public let serviceID: String
    public let apiURL: String

    public init?(withService service: Service) {

        guard let credentials = service.credentials,
            let url = credentials["url"] as? String,
            let username = credentials["agentUsername"] as? String,
            let password = credentials["agentPassword"] as? String,
            let appID = credentials["app_id"] as? String,
            let serviceID = credentials["service_id"] as? String,
            let apiURL = credentials["api_url"] as? String
            else {
                return nil
        }

        self.url = url
        self.username = username
        self.password = password
        self.appID = appID
        self.serviceID = serviceID
        self.apiURL = apiURL

        super.init(name: service.name,
                   label: service.label,
                   plan: service.plan,
                   tags: service.tags,
                   credentials: service.credentials)
    }
}

/// Contains the configuration values for a Cloudant service instance
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

/// Contains the configuration values for a DB2 service instance
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

/// Contains the configuration values for a MongoDB service instance
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

/// Contains the configuration values for an Object Storage service instance
public class ObjectStorageService: Service {

    public let authURL:     String
    public let project:     String
    public let projectID:   String
    public let region:      String
    public let userID:      String
    public let username:    String
    public let password:    String
    public let domainID:    String
    public let domainName:  String

    public init?(withService service: Service) {

        guard let credentials = service.credentials,
            let authURL     = credentials["auth_url"] as? String,
            let project     = credentials["project"] as? String,
            let projectID   = credentials["projectId"] as? String,
            let region      = credentials["region"] as? String,
            let userID      = credentials["userId"] as? String,
            let username    = credentials["username"] as? String,
            let password    = credentials["password"] as? String,
            let domainID    = credentials["domainId"] as? String,
            let domainName  = credentials["domainName"] as? String
            else {

                return nil

        }

        self.authURL = authURL
        self.project = project
        self.projectID = projectID
        self.region = region
        self.userID = userID
        self.username = username
        self.password = password
        self.domainID = domainID
        self.domainName = domainName

        super.init(name:        service.name,
                   label:       service.label,
                   plan:        service.plan,
                   tags:        service.tags,
                   credentials: service.credentials)

    }

}

/// Contains the configuration values for a PostgreSQL service instance
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

/// Contains the configuration values for a Redis service instance
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

/// Contains the configuration values for a MySQL service instance
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

    /// Contains the configuration values for a MySQL service instance
    public class WatsonConversationService: Service {

        public let username         : String
        public let password         : String
        public let url              : String

        public init?(withService service: Service) {

            guard let credentials = service.credentials,
                let username   = credentials["username"] as? String,
                let password   = credentials["password"] as? String,
                let url = credentials["url"] as? String, {
                    return nil
            }

            self.username = username
            self.password = password
            self.url = url

            super.init(name:        service.name,
                    label:       service.label,
                    plan:        service.plan,
                    tags:        service.tags,
                    credentials: service.credentials)
        }
}
