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

/// Contains the credentials for a PushSDK service instance. You will typically
/// receive an instance of this type through `cloudEnv.getPushSDKCredentials(name: String)`.
///
/// Reference [Push Notification](https://console.ng.bluemix.net/catalog/services/push-notifications).
public class PushSDKCredentials {

  /// The appGuid from the Push Notification service instance credentials.
  public let appGuid      : String
  /// The apiKey from the Push Notification service instance credentials.
  public let apiKey       : String
  /// The region from the Push Notification service instance credentials.
  public let region       : String

  /// Initializes an instance of the Push Notification service credentials.
  public init(appGuid: String, apiKey: String, region: String) {
    self.appGuid        = appGuid
    self.apiKey         = apiKey
    self.region         = region
  }

}

extension CloudEnv {

  /// Returns a PushSDKCredentials object with the corresponding credentials.
  ///
  /// ### Usage Example: ###
  /// ```swift
  /// let cloudEnv = CloudEnv()
  ///
  /// credentials =  cloudEnv.getPushSDKCredentials(name: "PushNotificationKey")
  /// ```
  /// - Parameter name: The key to lookup the credentials.
  public func getPushSDKCredentials(name: String) -> PushSDKCredentials? {

    guard let credentials = getDictionary(name: name),
      let appGuid = credentials["appGuid"] as? String ?? credentials["app_guid"] as? String,
      let apiKey = credentials["apikey"] as? String,
      let pushURL = credentials["url"] as? String,
      let url = URL(string: pushURL),
      let region = getRegion(from: url)
      else {
        return nil
    }

    return PushSDKCredentials(appGuid: appGuid, apiKey: apiKey, region: region)
  }

  private func getRegion(from url: URL) -> String? {
    guard let host = url.host,
      host.hasSuffix(".bluemix.net")
    else{
      return nil
    }
    let parts = host.split(separator: ".").suffix(3)
    guard parts.count > 2 && parts.first != "imfpush" else {
      return nil
    }
    return parts.joined(separator: ".")
  }
}
