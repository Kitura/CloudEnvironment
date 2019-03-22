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

/// Contains the credentials for a Watson Assistant service instance. You will typically
/// receive an instance of this type through `cloudEnv.getWatsonAssistantCredentials(name: String)`.
///
/// Reference [Watson Assistant](https://cloud.ibm.com/catalog/services/watson-assistant).
public class WatsonAssistantCredentials {

    /// The apiKey from the Watson Assistant service instance credentials.
    public let apiKey:   String
    /// The URL from the Watson Assistant service instance credentials.
    public let url:      String

    /// Initializes an instance of the Watson Assistant service credentials.
    public init(apiKey: String, url: String) {
        self.apiKey  = apiKey
        self.url     = url
    }
}

extension CloudEnv {

  /// Returns an WatsonAssistantCredentials object with the corresponding credentials.
  ///
  /// ### Usage Example: ###
  /// ```swift
  /// let cloudEnv = CloudEnv()
  ///
  /// credentials =  cloudEnv.getWatsonAssistantCredentials(name: "WatsonAssistantCredentialsKey")
  /// ```
  /// - Parameter name: The key to lookup the environment variable.
  public func getWatsonAssistantCredentials(name: String) -> WatsonAssistantCredentials? {
    guard let credentials = getDictionary(name: name),
      let apiKey  = credentials["apikey"] as? String,
      let url     = credentials["url"] as? String else {

      return nil
    }

    return WatsonAssistantCredentials(apiKey: apiKey, url: url)
  }
}
