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

/// Contains the credentials for a Cloud Functions instance. You will typically
/// receive an instance of this type through `cloudEnv.getCloudFunctionsCredentials(name: String)`.
///
/// Reference [Cloud Functions](https://cloud.ibm.com/openwhisk).
public struct CloudFunctionsCredentials {

  /// Cloud Functions host name.
  public let hostName: String

  /// URL path to the Cloud Functions action.
  public let urlPath: String

  /// The base64 encoded auth token.
  public let authToken: String

  /// Initializes an instance of the Cloud Functions service credentials.
  public init(hostName: String, urlPath: String, authToken: String) {
    self.hostName = hostName
    self.urlPath = urlPath
    self.authToken = authToken
  }

  // Constructor
  fileprivate init?(dict: [String: Any]) {
    guard let CloudFunctionsJson = dict as? [String: String] else {
      return nil
    }

    guard let hostName = CloudFunctionsJson["hostName"],
          let urlPath = CloudFunctionsJson["urlPath"],
          let authToken = CloudFunctionsJson["authToken"],
          let computedAuthToken = authToken.data(using: String.Encoding.utf8)?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)) else {

            return nil
    }

    self.hostName = hostName
    self.urlPath = urlPath
    self.authToken = computedAuthToken
  }
}

extension CloudEnv {

  /// Returns a CloudFunctionsCredentials object with the corresponding credentials.
  ///
  /// ### Usage Example: ###
  /// ```swift
  /// let cloudEnv = CloudEnv()
  ///
  /// credentials =  cloudEnv.getCloudFunctionsCredentials(name: "CloudFunctionsKey")
  /// ```
  /// - Parameter name: The key to lookup the credentials.
  public func getCloudFunctionsCredentials(name: String) -> CloudFunctionsCredentials? {

    guard let credentials = getDictionary(name: name) else {
        return nil
    }

    return CloudFunctionsCredentials(dict: credentials)
  }

}
