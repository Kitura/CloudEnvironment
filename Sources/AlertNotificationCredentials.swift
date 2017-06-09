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

/// Contains the credentials for an Alert Notification service instance
public class AlertNotificationCredentials {

    public let url:         String
    public let id:          String
    public let password:    String
    public let swaggerUI:   String

    public init (
        url:        String,
        id:         String,
        password:   String,
        swaggerUI:  String ) {

        self.url        = url
        self.id         = id
        self.password   = password
        self.swaggerUI  = swaggerUI
        
    }
}

extension ConfigurationManager {

    public func getAlertNotificationCredentials (name: String) -> AlertNotificationCredentials? {

        guard let credentials = getServiceCreds(spec: name),
            let url         = credentials["url"] as? String,
            let id          = credentials["name"] as? String,
            let password    = credentials["password"] as? String,
            let swaggerUI   = credentials["swaggerui"] as? String else {

                return nil
        }

        return AlertNotificationCredentials (
            url:        url,
            id:         id,
            password:   password,
            swaggerUI:  swaggerUI )

    }

}
