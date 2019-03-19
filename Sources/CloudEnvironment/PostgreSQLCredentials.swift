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

/// Contains the credentials for a PostgreSQL service instance. You will typically
/// receive an instance of this type through `cloudEnv.getPostgreSQLCredentials(name: String)`.
///
/// Reference [PostgreSQL](https://console.ng.bluemix.net/catalog/services/compose-for-postgresql/).
public class PostgreSQLCredentials: Credentials {

  /// The database name from the PostgreSQL service instance credentials.
  public let database: String

  /// Initializes an instance of the PostgreSQL service credentials.
  init?(uri: String) {
    guard let parsedURL = URLComponents(string: uri) else {
      return nil
    }
    // Remove slash from path
    var database = parsedURL.path
    database.remove(at: database.startIndex)

    if database.count == 0 {
      return nil
    }

    self.database = database
    super.init(url: uri)
  }
}

extension CloudEnv {

  /// Returns an PostgreSQLCredentials object with the corresponding credentials.
  ///
  /// ### Usage Example: ###
  /// ```swift
  /// let cloudEnv = CloudEnv()
  ///
  /// credentials =  cloudEnv.getPostgreSQLCredentials(name: "PostgreSQLKey")
  /// ```
  /// - Parameter name: The key to lookup the environment variable.
  public func getPostgreSQLCredentials(name: String) -> PostgreSQLCredentials? {
    guard let credentials = getDictionary(name: name),
      let uri = credentials["uri"] as? String else {
      return nil
    }

    return PostgreSQLCredentials(uri: uri)
  }

}
