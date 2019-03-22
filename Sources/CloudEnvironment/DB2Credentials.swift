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

/// Contains the credentials for a DB2 service instance. You will typically
/// receive an instance of this type through `cloudEnv.getDB2Credentials(name: String)`.
///
/// Reference [Db2](https://cloud.ibm.com/catalog/services/db2-hosted).
public class DB2Credentials {

  /// The database name from the Db2 service instance credentials.
  public let database : String
  /// The host name from the Db2 service instance credentials.
  public let host     : String
  /// The port from the Db2 service instance credentials.
  public let port     : Int
  /// The user ID from the Db2 service instance credentials.
  public let uid      : String
  /// The password from the Db2 service instance credentials.
  public let pwd      : String

  /// Initializes an instance of the Db2 service credentials.
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

extension CloudEnv {

  /// Returns an DB2Credentials object with the corresponding credentials.
  ///
  /// ### Usage Example: ###
  /// ```swift
  /// let cloudEnv = CloudEnv()
  ///
  /// credentials =  cloudEnv.getDB2Credentials(name: "DB2Key")
  /// ```
  /// - Parameter name: The key to lookup the environment variable.
  public func getDB2Credentials (name: String) -> DB2Credentials? {

    guard let credentials = getDictionary(name: name),
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
