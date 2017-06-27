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

/// Contains the credentials for an AppID service instance
public class AppIDCredentials {

    public let clientId:       String
    public let oauthServerUrl: String
    public let profilesUrl:    String
    public let secret:         String
    public let tenantId:       String
    public let version:        Int

    public init (
        clientId:       String,
        oauthServerUrl: String,
        profilesUrl:    String,
        secret:         String,
        tenantId:       String,
        version:        Int ) {

        self.clientId       = clientId
        self.oauthServerUrl = oauthServerUrl
        self.profilesUrl    = profilesUrl
        self.secret         = secret
        self.tenantId       = tenantId
        self.version        = version
        
    }
}

extension AppConfiguration {

    public func getAppIDCredentials (name: String) -> AppIDCredentials? {

        guard let credentials   = getCredentials(name: name),
            let clientId        = credentials["clientId"] as? String,
            let oauthServerUrl  = credentials["oauthServerUrl"] as? String,
            let profilesUrl     = credentials["profilesUrl"] as? String,
            let secret          = credentials["secret"] as? String,
            let tenantId        = credentials["tenantId"] as? String,
            let version         = credentials["version"] as? Int else {

                return nil
        }

        return AppIDCredentials (
            clientId:       clientId,
            oauthServerUrl: oauthServerUrl,
            profilesUrl:    profilesUrl,
            secret:         secret,
            tenantId:       tenantId,
            version:        version )
        
    }
    
}
