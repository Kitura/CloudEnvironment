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

/// PushSDKCredentials class
///
/// Contains the credentials for a PushSDK service instance.
import Foundation

public class PushSDKCredentials {

  public let appGuid      : String
  public let apiKey       : String
  public let region       : String

  public init(appGuid: String, apiKey: String, region: String) {
    self.appGuid        = appGuid
    self.apiKey         = apiKey
    self.region         = region
  }

}

extension CloudEnv {

  /// Returns a PushSDKCredentials object with the corresponding credentials.
  ///
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
