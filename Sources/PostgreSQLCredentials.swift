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

/// Contains the credentials for a PostgreSQL service instance
public class PostgreSQLCredentials {

    public let host        : String
    public let port        : Int
    public let username    : String
    public let password    : String

    public init (
        host:       String,
        port:       Int,
        username:   String,
        password:   String ){

        self.host       = host
        self.port       = port
        self.username   = username
        self.password   = password

    }
}

extension AppConfiguration {

    public func getPostgreSQLCredentials (name: String) -> PostgreSQLCredentials? {

        guard let credentials = getCredentials (name: name),
            let uri         = credentials["uri"] as? String,
            let url         = URL(string: uri),
            let host        = url.host,
            let port        = url.port,
            let username    = url.user,
            let password    = url.password else {

                return nil
        }

        return PostgreSQLCredentials (
            host: host,
            port: port,
            username: username,
            password: password )

    }

}
