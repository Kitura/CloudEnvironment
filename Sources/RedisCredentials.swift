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

/// Contains the credentials for a Redis service instance
public class RedisCredentials {

    public let host        : String
    public let password    : String
    public let port        : Int

    public init (
        host:       String,
        password:   String,
        port:       Int ) {

        self.host       = host
        self.password   = password
        self.port       = port

    }
}

extension AppConfiguration {

    public func getRedisCredentials (name: String) -> RedisCredentials? {

        guard let credentials = getCredentials (name: name),
            let uri         = credentials["uri"] as? String,
            let url         = URL(string: uri),
            let host        = url.host,
            let password    = url.password,
            let port        = url.port else {

                return nil
        }

        return RedisCredentials (
            host:       host,
            password:   password,
            port:       port)
        
    }
    
}
