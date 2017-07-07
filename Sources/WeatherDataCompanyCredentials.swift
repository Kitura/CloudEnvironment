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

/// Contains the credentials for a Weather Company Data service instance
public class WeatherCompanyDataCredentials {

    public let username : String
    public let password : String
    public let host     : String
    public let port     : Int
    public let url      : String

    public init (
        username:   String,
        password:   String,
        host:       String,
        port:       Int,
        url:        String ){

        self.username   = username
        self.password   = password
        self.host       = host
        self.port       = port
        self.url        = url

    }
}

extension AppConfiguration {

    public func getWeatherCompanyDataCredentials(name: String) -> WeatherCompanyDataCredentials? {

        guard let credentials = getCredentials(name: name),
            let username    = credentials["username"] as? String,
            let password    = credentials["password"] as? String,
            let host        = credentials["host"] as? String,
            let port        = credentials["port"] as? Int,
            let url         = credentials["url"] as? String else {

                return nil
        }

        return WeatherCompanyDataCredentials (
            username:   username,
            password:   password,
            host:       host,
            port:       port,
            url:        url )
        
    }
    
}
