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

/// Contains the credentials for a Redis service instance. You will typically
/// receive an instance of this type through `cloudEnv.getRedisCredentials(name: String)`.
///
/// Reference [Redis](https://console.ng.bluemix.net/catalog/services/compose-for-redis).
public class RedisCredentials {

  /// The host name from the Redis service instance credentials.
  public let host: String
  /// The password from the Redis service instance credentials.
  public let password: String
  /// The port from the Redis service instance credentials.
  public let port: Int

  /// Initializes an instance of the Redis service credentials.
  public init(host: String, password: String, port: Int ) {
    self.host = host
    self.password = password
    self.port = port
  }
}

extension CloudEnv {
  /// Returns an RedisCredentials object with the corresponding credentials.
  ///
  /// ### Usage Example: ###
  /// ```swift
  /// let cloudEnv = CloudEnv()
  ///
  /// credentials =  cloudEnv.getRedisCredentials(name: "RedisKey")
  /// ```
  /// - Parameter name: The key to lookup the environment variable.
  public func getRedisCredentials(name: String) -> RedisCredentials? {

    guard let credentials = getDictionary(name: name),
      let uri = credentials["uri"] as? String,
      let url = URL(string: uri),
      let host = url.host,
      let password = url.password,
      let port = url.port else {

      return nil
    }

    return RedisCredentials(host: host, password: password, port: port)
  }

}
