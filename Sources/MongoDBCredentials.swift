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
import Configuration
import CloudFoundryEnv

/// Contains the credentials for a MongoDB service instance
public class MongoDBCredentials {

    public let host        : String
    public let username    : String
    public let password    : String
    public let port        : Int
    public let certificate : String

    public init (
        host:           String,
        username:       String,
        password:       String,
        port:           Int,
        certificate:    String ) {

        self.host           = host
        self.username       = username
        self.password       = password
        self.port           = port
        self.certificate    = certificate
        
    }
}

extension AppConfiguration {

    public func getMongoDBCredentials (name: String) -> MongoDBCredentials? {

        guard let credentials = getCredentials (name: name) else {
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

        return MongoDBCredentials (
            host:           host,
            username:       username,
            password:       password,
            port:           port,
            certificate:    certificate )
    }
}
