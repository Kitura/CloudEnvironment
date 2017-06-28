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

import Configuration
import CloudFoundryEnv

/// Contains the credentials for a Cloudant service instance
public class CloudantCredentials {

    public let host        : String
    public let username    : String
    public let password    : String
    public let port        : Int
    public let secured     : Bool
    public let url         : String

    public init (
        host:       String,
        username:   String,
        password:   String,
        port:       Int,
        secured:    Bool,
        url:        String ) {

        self.host       = host
        self.username   = username
        self.password   = password
        self.port       = port
        self.secured    = secured
        self.url        = url

    }
}

extension AppConfiguration {

    public func getCloudantCredentials(name: String) -> CloudantCredentials? {

        guard let credentials = getCredentials(name: name),
            let host      = credentials["host"] as? String,
            let username  = credentials["username"] as? String,
            let password  = credentials["password"] as? String,
            let port      = credentials["port"] as? Int,
            let url       = credentials["url"] as? String else {

                return nil
        }

        let secured: Bool = credentials["secured"] as? Bool ?? true

        return CloudantCredentials (
            host: host,
            username: username,
            password: password,
            port: port,
            secured: secured,
            url: url )
        
    }
    
}
