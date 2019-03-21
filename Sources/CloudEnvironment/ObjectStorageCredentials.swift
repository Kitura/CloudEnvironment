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

/// Contains the credentials for an OpenStack Object Storage service instance. You will typically
/// receive an instance of this type through `cloudEnv.getObjectStorageCredentials(name: String)`.
///
/// Note: This has been removed from the IBM Cloud service catalog, but is still an industry
/// standard for Storage APIs.
///
/// Reference [Object Storage](https://docs.openstack.org/swift/latest/).
public class ObjectStorageCredentials {

  /// The project ID from the Object Storage service instance credentials.
  public let projectID:   String
  /// The user ID from the Object Storage service instance credentials.
  public let userID:      String
  /// The password from the Object Storage service instance credentials.
  public let password:    String
  /// The region from the Object Storage service instance credentials.
  public let region:      String

  /// Initializes an instance of the Object Storage service credentials.
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
  /// ### Usage Example: ###
  /// ```swift
  /// let cloudEnv = CloudEnv()
  ///
  /// credentials =  cloudEnv.getObjectStorageCredentials(name: "ObjectStorageKey")
  /// ```
  /// - Parameter name: The key to lookup the environment variable.
  public func getObjectStorageCredentials(name: String) -> ObjectStorageCredentials? {
    guard let credentials = getDictionary(name: name),
      let projectID   = credentials["projectId"] as? String ?? credentials["project_id"] as? String,
      let region      = credentials["region"] as? String,
      let userID      = credentials["userId"] as? String ?? credentials["user_id"] as? String,
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
