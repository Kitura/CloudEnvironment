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

/// Contains the credentials for a PushSDK service instance
public class PushSDKCredentials {

    public let appGuid      : String
    public let url          : String
    public let admin_url    : String
    public let appSecret    : String
    public let clientSecret : String

    public init (
        appGuid:        String,
        url:            String,
        admin_url:      String,
        appSecret:      String,
        clientSecret:   String ){

        self.appGuid        = appGuid
        self.url            = url
        self.admin_url      = admin_url
        self.appSecret      = appSecret
        self.clientSecret   = clientSecret

    }
}

extension AppConfiguration {

    public func getPushSDKCredentials (name: String) -> PushSDKCredentials? {

        guard let credentials = getCredentials (name: name),
            let appGuid         = credentials["appGuid"] as? String,
            let url             = credentials["url"] as? String,
            let admin_url       = credentials["admin_url"] as? String,
            let appSecret       = credentials["appSecret"] as? String,
            let clientSecret    = credentials["clientSecret"] as? String else {

                return nil
        }

        return PushSDKCredentials (
            appGuid:        appGuid,
            url:            url,
            admin_url:      admin_url,
            appSecret:      appSecret,
            clientSecret:   clientSecret )

    }

}
