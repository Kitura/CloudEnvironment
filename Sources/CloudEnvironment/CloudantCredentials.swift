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

/// Contains the credentials for a Cloudant service instance. You will typically
/// receive an instance of this type through `cloudEnv.getCloudantCredentials(name: String)`.
///
/// Reference [Cloudant](https://cloud.ibm.com/catalog/services/cloudant).
public class CloudantCredentials: Credentials {
  // Just a simpler wrapper to provide a type for Cloudant credentials
}

extension CloudEnv {

  /// Returns a CloudantCredentials object with the corresponding credentials.
  ///
  /// ### Usage Example: ###
  /// ```swift
  /// let cloudEnv = CloudEnv()
  ///
  /// credentials =  cloudEnv.getCloudantCredentials(name: "CloudantKey")
  /// ```
  /// - Parameter name: The key to lookup the environment variable.
  public func getCloudantCredentials(name: String) -> CloudantCredentials? {
    guard let credentials = getDictionary(name: name),
    let username  = credentials["username"] as? String,
    let password  = credentials["password"] as? String,
    let url       = credentials["url"] as? String else {
      return nil
    }

    return CloudantCredentials(
      username: username,
      password: password,
      url: url
    )
  }

}
