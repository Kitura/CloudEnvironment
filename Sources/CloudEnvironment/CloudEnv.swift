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

import Configuration
import CloudFoundryEnv
import Foundation
import LoggerAPI

/// CloudEnv class
///
/// Convenience class for obtaining environment variables that are mapped to JSON strings.
/// Mainly used for obtaining credentials for services so Swift applications can be written in
/// a platform agnostic way.
public class CloudEnv {

  /// Name of mappings file (mappings.json).
  public static let mappingsFile = "mappings.json"

  /// Port number application can listen to.
  public var port: Int {
    let cloudFoundryManager = getCloudFoundryConfigMgr()
    return cloudFoundryManager.port
  }

  /// URL that can be assigned to application.
  public var url: String {
    let cloudFoundryManager = getCloudFoundryConfigMgr()
    return cloudFoundryManager.url
  }

  // Instance variables/constants
  private let mapManager = ConfigurationManager()
  private let cloudFoundryFile: String?

  /// Constructor
  ///
  /// - Parameter mappingsFilePath: Optional. The path to the `mappings.json` file; this path should be relative to the root folder of the Swift application.
  /// - Parameter cloudFoundryFile: Optional. The path to a JSON file that contains values for Cloud Foundry environment variables (mainly used for testing);
  /// this path should also be relative to the root folder of the Swift application.
  public init(mappingsFilePath: String? = nil, cloudFoundryFile: String? = nil) {

    // Set instance properties
    self.cloudFoundryFile = cloudFoundryFile

    // Compute path to mappings.json
    let filePath: String = (mappingsFilePath == nil) ? "config" : mappingsFilePath!

    // For local execution
    mapManager.load(file: "\(filePath)/\(CloudEnv.mappingsFile)", relativeFrom: .project)

    // For Cloud Foundry
    mapManager.load(file: "\(filePath)/\(CloudEnv.mappingsFile)", relativeFrom: .pwd)
  }

  /// Returns the corresponding JSON dictionary value in a string.
  ///
  /// - Parameter name: The key to lookup the environment variable.
  public func getString(name: String) -> String? {
    if let dictionary = getDictionary(name: name) {
      //if let jsonData = try? JSONSerialization.data(withJSONObject: credentials, options: .prettyPrinted) {
      if let jsonData = try? JSONSerialization.data(withJSONObject: dictionary) {
        return String(data: jsonData, encoding: String.Encoding.utf8)
      }
    }
    return nil
  }

  /// Returns the corresponding dictionary value.
  ///
  /// - Parameter name: The key to lookup the environment variable.
  public func getDictionary(name: String) -> [String:Any]? {

    guard let searchPatterns = mapManager["\(name):searchPatterns"] as? [String] else {
      Log.debug("No search patterns found. There may have been a problem loading '\(CloudEnv.mappingsFile)'.")
      return nil
    }

    for pattern in searchPatterns {

      var arr = pattern.components(separatedBy: ":")
      let key = arr.removeFirst()
      let value = arr.removeFirst()

      switch (key) {
      case "cloudfoundry":    // Cloud Foundry/swift-cfenv
        if let credentials = getCloudFoundryDict(name: value) {
          Log.debug("Found dictionary in Cloud Foundry env.")
          return credentials
        }
        break
      case "env":             // Kubernetes
        if let credentials = getKubeDict(evName: value) {
          Log.debug("Found dictionary in environment variable.")
          return credentials
        }
        break
      case "file":            // File- local or in cloud foundry
        let instance = (arr.count > 0) ? arr[0] : ""
        if let credentials = getFileDict(instance: instance, path: value),
        credentials.count > 0 {
          Log.debug("Found dictionary in referenced file.")
          return credentials
        }
        break
      default:
        Log.error("Failed to found dictionary; invalid key: '\(key)'.")
        return nil
      }
    }
    Log.error("Failed to find dictionary.")
    return nil
  }

  private func getCloudFoundryDict(name: String) -> [String:Any]? {
    let cloudFoundryManager = getCloudFoundryConfigMgr()
    let credentials = cloudFoundryManager.getServiceCreds(spec: name)
    return credentials
  }

  private func getKubeDict(evName: String) -> [String:Any]? {
    let kubeManager = ConfigurationManager().load(.environmentVariables)
    let credentials = kubeManager["\(evName)"] as? [String: Any]
    return credentials
  }

  private func getFileDict(instance: String, path: String) -> [String:Any]? {
    let fileManager = ConfigurationManager()

    // For local mapping file
    fileManager.load(file: path, relativeFrom: .project)

    // Load file in cloud foundry-- extract filename from path
    if let fileName = path.components(separatedBy: "/").last {
      fileManager.load(file: fileName, relativeFrom: .pwd)
    }

    if instance.isEmpty {
      return (fileManager.getConfigs() as? [String: Any])
    } else {
      return fileManager["\(instance)"] as? [String: Any]
    }
  }
  private func getCloudFoundryConfigMgr() -> ConfigurationManager {
    // Create config mgr instance for Cloud Foundry
    let cloudFoundryManager = ConfigurationManager()

    // Load configuration for cloud foundry
    if let cloudFoundryFile = self.cloudFoundryFile {
      cloudFoundryManager.load(file: cloudFoundryFile, relativeFrom: .project)
    } else {
      cloudFoundryManager.load(.environmentVariables)
    }

    return cloudFoundryManager
  }

}
