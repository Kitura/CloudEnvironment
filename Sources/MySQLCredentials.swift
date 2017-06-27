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

/// Contains the credentials for a MySQL service instance
public class MySQLCredentials {

    public let database : String
    public let host     : String
    public let username : String
    public let password : String
    public let port     : Int

    public init (
        database:   String,
        host:       String,
        username:   String,
        password:   String,
        port:       Int ) {

        self.database   = database
        self.host       = host
        self.username   = username
        self.password   = password
        self.port       = port

    }
}

extension AppConfiguration {

    public func getMySQLCredentials (name: String) -> MySQLCredentials? {

        guard let credentials = getCredentials (name: name),
            let database    = credentials["name"] as? String,
            let host        = credentials["hostname"] as? String,
            let username    = credentials["username"] as? String,
            let password    = credentials["password"] as? String,
            let stringPort  = credentials["port"] as? String,
            let port        = Int(stringPort) else {

                return nil
        }

        return MySQLCredentials (
            database: database,
            host: host,
            username: username,
            password: password,
            port: port)
    }
    
}
