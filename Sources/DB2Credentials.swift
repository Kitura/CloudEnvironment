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

/// Contains the credentials for a DB2 service instance
public class DB2Credentials {

    public let database : String
    public let host     : String
    public let port     : Int
    public let uid      : String
    public let pwd      : String

    public init (
        database:   String,
        host:       String,
        port:       Int,
        uid:        String,
        pwd:        String ) {

        self.database   = database
        self.host       = host
        self.port       = port
        self.uid        = uid
        self.pwd        = pwd

    }
}

extension AppConfiguration {

    public func getDB2Credentials (name: String) -> DB2Credentials? {

        guard let credentials = getCredentials (name: name),
            let database    = credentials["db"] as? String,
            let host        = credentials["host"] as? String,
            let port        = credentials["port"] as? Int,
            let uid         = credentials["username"] as? String,
            let pwd         = credentials["password"] as? String else {

                return nil
        }

        return DB2Credentials (
            database:   database,
            host:       host,
            port:       port,
            uid:        uid,
            pwd:        pwd )
        
    }
    
}
