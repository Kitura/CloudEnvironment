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

/// ObjectStorageCredentials class
///
/// Contains the credentials for an Object Storage service instance.
public class ObjectStorageCredentials {

  public let projectID:   String
  public let userID:      String
  public let password:    String
  public let region:      String

  public init(projectID: String, userID: String, password: String, region: String) {
    self.projectID  = projectID
    self.userID     = userID
    self.password   = password
    self.region     = region
  }
}

extension CloudEnv {

  /// Returns an ObjectStorageCredentials object with the corresponding credentials.
  ///
  /// - Parameter name: The key to lookup the environment variable.
  public func getObjectStorageCredentials (name: String) -> ObjectStorageCredentials? {
    guard let credentials = getDictionary(name: name),
      let projectID   = credentials["projectId"] as? String,
      let region      = credentials["region"] as? String,
      let userID      = credentials["userId"] as? String,
      let password    = credentials["password"] as? String else {
      return nil
    }

    return ObjectStorageCredentials(
      projectID: projectID,
      userID: userID,
      password: password,
      region: region)
  }

}
