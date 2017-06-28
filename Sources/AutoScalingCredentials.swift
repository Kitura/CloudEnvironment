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

/// Contains the credentials for an Auto Scaling service instance
public class AutoScalingCredentials {

    public let username:    String
    public let password:    String
    public let appID:       String
    public let url:         String
    public let serviceID:   String
    public let apiURL:      String

    public init (
        username:   String,
        password:   String,
        appID:      String,
        url:        String,
        serviceID:  String,
        apiURL:     String ) {

        self.username   = username
        self.password   = password
        self.appID      = appID
        self.url        = url
        self.serviceID  = serviceID
        self.apiURL     = apiURL

    }
}

extension AppConfiguration {

    public func getAutoScalingCredentials (name: String) -> AutoScalingCredentials? {

        guard let credentials   = getCredentials (name: name),
            let username        = credentials["agentUsername"] as? String,
            let password        = credentials["agentPassword"] as? String,
            let appID           = credentials["app_id"] as? String,
            let url             = credentials["url"] as? String,
            let serviceID       = credentials["service_id"] as? String,
            let apiURL          = credentials["api_url"] as? String else {

                return nil
        }

        return AutoScalingCredentials (
            username:   username,
            password:   password,
            appID:      appID,
            url:        url,
            serviceID:  serviceID,
            apiURL:     apiURL )
        
    }
    
}
