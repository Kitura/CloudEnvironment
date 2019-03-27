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

/// Contains the credentials for an App ID service instance.
///
/// Reference [AppID](https://cloud.ibm.com/catalog/services/appID). You will typically
/// receive an instance of this type through `cloudEnv.getAppIDCredentials(name: String)`.
public class AppIDCredentials {

  /// The clientId from the App ID service instance credentials.
  public let clientId:       String
  /// The oauthServerUrl from the App ID service instance credentials.
  public let oauthServerUrl: String
  /// The profilesUrl from the App ID service instance credentials.
  public let profilesUrl:    String
  /// The secret from the App ID service instance credentials.
  public let secret:         String
  /// The tenantId from the App ID service instance credentials.
  public let tenantId:       String

  /// Initializes an instance of the App ID service credentials.
  public init(
    clientId:       String,
    oauthServerUrl: String,
    profilesUrl:    String,
    secret:         String,
    tenantId:       String) {

    self.clientId       = clientId
    self.oauthServerUrl = oauthServerUrl
    self.profilesUrl    = profilesUrl
    self.secret         = secret
    self.tenantId       = tenantId
  }
}

extension CloudEnv {

  /// Returns an AppIDCredentials object with the corresponding credentials.
  /// ### Usage Example: ###
  /// ```swift
  /// let cloudEnv = CloudEnv()
  ///
  /// credentials =  cloudEnv.getAppIDCredentials(name: "AppIDKey")
  /// ```
  ///
  /// - Parameter name: The key to lookup the environment variable.
  public func getAppIDCredentials(name: String) -> AppIDCredentials? {

    guard let credentials   = getDictionary(name: name),
    let clientId        = credentials["clientId"] as? String ?? credentials["client_id"] as? String,
    let oauthServerUrl  = credentials["oauthServerUrl"] as? String ?? credentials["oauth_server_url"] as? String,
    let profilesUrl     = credentials["profilesUrl"] as? String ?? credentials["profiles_url"] as? String,
    let secret          = credentials["secret"] as? String,
    let tenantId        = credentials["tenantId"] as? String ?? credentials["tenant_id"] as? String else {
      return nil
    }

    return AppIDCredentials(
      clientId:       clientId,
      oauthServerUrl: oauthServerUrl,
      profilesUrl:    profilesUrl,
      secret:         secret,
      tenantId:       tenantId)
  }

}
