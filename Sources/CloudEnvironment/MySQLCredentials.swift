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

/// Contains the credentials for a MySQL service instance. You will typically
/// receive an instance of this type through `cloudEnv.getMySQLCredentials(name: String)`.
///
/// Reference [MySQL](https://cloud.ibm.com/catalog/services/compose-for-mysql).
public class MySQLCredentials {

  /// The database name from the MySQL service instance credentials.
  public let database : String
  /// The host name from the MySQL service instance credentials.
  public let host     : String
  /// The username from the MySQL service instance credentials.
  public let username : String
  /// The password from the MySQL service instance credentials.
  public let password : String
  /// The port from the MySQL service instance credentials.
  public let port     : Int

  /// Initializes an instance of the MySQL service credentials.
  public init(
    database:   String,
    host:       String,
    username:   String,
    password:   String,
    port:       Int) {

    self.database   = database
    self.host       = host
    self.username   = username
    self.password   = password
    self.port       = port

  }
}

extension CloudEnv {

  /// Returns an MySQLCredentials object with the corresponding credentials.
  ///
  /// ### Usage Example: ###
  /// ```swift
  /// let cloudEnv = CloudEnv()
  ///
  /// credentials =  cloudEnv.getMySQLCredentials(name: "MySQLKey")
  /// ```
  /// - Parameter name: The key to lookup the environment variable.
  public func getMySQLCredentials (name: String) -> MySQLCredentials? {

    guard let credentials = getDictionary(name: name),
      let database    = credentials["name"] as? String,
      let host        = credentials["hostname"] as? String,
      let username    = credentials["username"] as? String,
      let password    = credentials["password"] as? String,
      let stringPort  = credentials["port"] as? String,
      let port        = Int(stringPort) else {

      return nil
    }

    return MySQLCredentials(
      database: database,
      host: host,
      username: username,
      password: password,
      port: port)
  }

}
