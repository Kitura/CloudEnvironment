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
  /// - Parameter mappingsFilePath: Optional. The absolute path to a `mappings.json` file.
  /// - Parameter cloudFoundryFile: Optional. The absolute path to a JSON file that contains values for Cloud Foundry environment variables.
  /// (mainly used for testing).
  public init(mappingsFileFolder: String? = nil, cloudFoundryFile: String? = nil) {

    // Set instance properties
    self.cloudFoundryFile = cloudFoundryFile

    // Compute path to mappings.json
    let mappingsFilePath: String = (mappingsFileFolder != nil) ? mappingsFileFolder! : "config"
 
    // Load mappings file (Cloud Foundry & local execution)
    // If running locally, make sure the app is started from the root folder of the project
    // In other words, the current working directory should be the project folder.
    mapManager.load(file: "\(mappingsFilePath)/\(CloudEnv.mappingsFile)", relativeFrom: .pwd)
  }

  /// Returns the corresponding JSON dictionary value in a string.
  ///
  /// - Parameter name: The key to lookup the environment variable.
  public func getString(name: String) -> String? {
    if let dictionary = getDictionary(name: name) {
      //if let jsonData = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted) {
      if let jsonData = try? JSONSerialization.data(withJSONObject: dictionary) {
        return String(data: jsonData, encoding: String.Encoding.utf8)
      }
    }
    return nil
  }

  /// Returns the corresponding dictionary value.
  ///
  /// - Parameter name: The key to lookup the environment variable.
  public func getDictionary(name: String) -> [String : Any]? {

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
        if let dictionary = getCloudFoundryDict(name: value) {
          Log.debug("Found dictionary entry in Cloud Foundry env.")
          return dictionary
        }
        break
      case "env":             // Kubernetes
        if let dictionary = getKubeDict(evName: value) {
          Log.debug("Found dictionary entry in environment variable.")
          return dictionary
        }
        break
      case "file":            // File- local or in cloud foundry
        let keyInFile = (arr.count > 0) ? arr[0] : ""
        if let dictionary = getFileDict(path: value, key: keyInFile),
        dictionary.count > 0 {
          Log.debug("Found dictionary entry in referenced file.")
          return dictionary
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

  private func getCloudFoundryDict(name: String) -> [String : Any]? {
    let cloudFoundryManager = getCloudFoundryConfigMgr()
    return cloudFoundryManager.getServiceCreds(spec: name)
  }

  private func getKubeDict(evName: String) -> [String:Any]? {
    let kubeManager = ConfigurationManager().load(.environmentVariables)
    return kubeManager["\(evName)"] as? [String : Any]
  }

  private func getFileDict(path: String, key: String) -> [String : Any]? {
    let sanitizedPath = sanitize(path: path)
    let fileManager = ConfigurationManager()

    // Load file in Cloud Foundry (working dir as base)
    fileManager.load(file: sanitizedPath, relativeFrom: .pwd)

    let dictionary = (key.isEmpty) ?
    (fileManager.getConfigs() as? [String : Any]) : fileManager["\(key)"] as? [String : Any]
    return dictionary
  }

  private func getCloudFoundryConfigMgr() -> ConfigurationManager {
    // Create config mgr instance for Cloud Foundry
    let cloudFoundryManager = ConfigurationManager()

    // Load configuration for cloud foundry
    if let cloudFoundryFile = self.cloudFoundryFile {
      cloudFoundryManager.load(file: cloudFoundryFile, relativeFrom: .pwd)
    } else {
      cloudFoundryManager.load(.environmentVariables)
    }

    return cloudFoundryManager
  }

  private func sanitize(path: String) -> String {
    if path.hasPrefix("/") {
      guard let range = path.range(of: "/") else {
        return path
      }
      return String(path[range.upperBound...])
    }
    return path
  }

}
