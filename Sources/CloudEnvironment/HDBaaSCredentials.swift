/*
* Copyright IBM Corporation 2018
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

/// Contains the credentials for a HyperSecureDBaaS service instance. You will typically
/// receive an instance of this type through `cloudEnv.getHyperSecureDBaaSCredentials(name: String)`.
///
/// Reference [Hyper Protect DBaaS](https://cloud.ibm.com/catalog/services/hyper-protect-dbaas).
public class HyperSecureDBaaSCredentials {

  /// The URI from the Hyper Protext DBaaS service instance credentials.
  public let uri: String
  /// The host from the Hyper Protext DBaaS service instance credentials.
  public let host: String
  /// The certificate from the Hyper Protext DBaaS service instance credentials.
  public let cert: String
  /// The username from the Hyper Protext DBaaS service instance credentials.
  public let username: String
  /// The password from the Hyper Protext DBaaS service instance credentials.
  public let password: String
  /// The port from the Hyper Protext DBaaS service instance credentials.
  public let port: Int

  /// Initializes an instance of the Hyper Protext DBaaS service credentials.
  public init(
    uri: String,
    host: String,
    cert: String,
    username: String,
    password: String,
    port: Int) {

    self.uri = uri
    self.host = host
    self.cert = cert
    self.username = username
    self.password = password
    self.port = port
  }
}

extension CloudEnv {

  /// Returns a HyperSecureDBaaSCredentials object with the corresponding credentials.
  ///
  /// ### Usage Example: ###
  /// ```swift
  /// let cloudEnv = CloudEnv()
  ///
  /// credentials =  cloudEnv.getHyperSecureDBaaSCredentials(name: "HyperSecureDBaaSKey")
  /// ```
  /// - Parameter name: The key to lookup the credentials object.
  public func getHyperSecureDBaaSCredentials(name: String) -> HyperSecureDBaaSCredentials? {

    guard let credentials = getDictionary(name: name) else {
      return nil
    }

    guard let uri = credentials["url"] as? String,
        let cert = credentials["cert"] as? String else {
        return nil
    }

    let uriItems = uri.components(separatedBy: ",")
    let filtered  = uriItems.filter({ $0.contains("ssl=true") })
    let uriValue: String?
    if filtered.count == 1, let dbInfo = filtered.first, var credentialInfo = uriItems.first,
      let atRange = credentialInfo.range(of: "@") {
        // Substitute non-ssl hostname:port with correct hostname:port
        credentialInfo.removeSubrange(atRange.upperBound..<credentialInfo.endIndex)
        uriValue = credentialInfo + dbInfo
    } else {
      uriValue = uriItems.first
    }

    guard let stringURL = uriValue, stringURL.count > 0,
      let url         = URL(string: stringURL),
      let host        = url.host,
      let username    = url.user,
      let password    = url.password,
      let port        = url.port else {

      return nil
    }

    return HyperSecureDBaaSCredentials(
      uri: uri,
      host: host,
      cert: cert,
      username: username,
      password: password,
      port: port)
  }
}
