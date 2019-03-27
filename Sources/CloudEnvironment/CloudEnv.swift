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

/// A convenience class for obtaining environment variables that are mapped to JSON strings.
/// It is mainly used for obtaining credentials for services so Swift applications can be written in
/// a platform agnostic way.
///
/// There is a lot of information in the [README](https://github.com/IBM-Swift/CloudEnvironment/blob/master/README.md)
/// explaining how you can use `cloudEnv` to access credentials for your services; more specific information is listed in the
/// API documentation below.
public class CloudEnv {

  /// Name of the mappings file. This is set to "mappings.json".
  public static let mappingsFile = "mappings.json"

  /// Port number the application can listen to.
  public var port: Int {
    let cloudFoundryManager = getCloudFoundryConfigMgr()
    return cloudFoundryManager.port
  }

  /// URL that can be assigned to the application.
  public var url: String {
    let cloudFoundryManager = getCloudFoundryConfigMgr()
    return cloudFoundryManager.url
  }

  // Instance variables/constants
  private let mapManager = ConfigurationManager()
  private let cloudFoundryFile: String?

  /// Initialize an instance of `CloudEnv`.
  /// ### Usage Example: ###
  /// ```swift
  /// let cloudEnv = CloudEnv()
  /// ```
  /// The example below shows how to load configuration from both a `mappings.json` file and a Cloud Foundry
  /// credentials file when neither are in the default directory.
  /// ```swift
  /// let cloudEnv = CloudEnv(mappingsFilePath: "resources/mappings", cloudFoundryFile: "resources
  /// cfresources/cf.json")
  /// ```
  /// - Parameter mappingsFilePath: Optional. The path to the `mappings.json` file; this path should be relative
  /// to the root folder of the Swift application.
  /// - Parameter cloudFoundryFile: Optional. The path to a JSON file that contains values for Cloud Foundry environment
  /// variables (mainly used for testing); this path should be relative to the current working directory (which in most
  /// cases is the folder of the Swift application).
  public init(mappingsFilePath: String? = nil, cloudFoundryFile: String? = nil) {

    // Set instance properties
    self.cloudFoundryFile = cloudFoundryFile

    // Compute path to mappings.json
    let filePath: String
    if let mappingsFilePath = mappingsFilePath {
      let sanitizedPath = sanitize(path: mappingsFilePath)
      filePath = sanitizedPath
    } else {
      filePath = "config"
    }

    // Load mappings file (Cloud Foundry & local execution)
    // If running locally, make sure the app is started from the project folder
    // In other words, the current working directory should be the project folder
    mapManager.load(file: "\(filePath)/\(CloudEnv.mappingsFile)", relativeFrom: .pwd)
  }

  /// Returns the corresponding JSON dictionary value in a string.
  ///
  /// If the service you intend to use in your Swift application is not one which we explicitly support,
  /// you can leverage the generic `getString(name: String)` method to get the corresponding credentials.
  /// ### Usage Example: ###
  /// ```swift
  /// let cloudEnv = CloudEnv()
  ///
  /// if let credentials = cloudEnv.getString(name: "service1-credentials") {
  ///   // You can now get the corresponding values from the credentials string.
  ///   // The result string will follow JSON notation.
  /// }
  /// ```
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
  /// If the service you intend to use in your Swift application is not one which we explicitly support,
  /// you can leverage the generic `getDictionary(name: String)` method to get the corresponding credentials.
  /// ### Usage Example: ###
  /// ```swift
  /// let cloudEnv = CloudEnv()
  ///
  /// if let credentials: [String:Any] = cloudEnv.getDictionary(name: "service1-credentials") {
  ///   // You can now get the corresponding values from the dictionary.
  /// }
  /// ```
  /// - Parameter name: The key to lookup the environment variable.
  public func getDictionary(name: String) -> [String : Any]? {

    guard let searchPatterns = mapManager["\(name):credentials:searchPatterns"] as? [String] else {
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
      #if swift(>=3.2)
        return String(path[range.upperBound...])
      #else
        return path.substring(from: range.upperBound)
      #endif

    }
    return path
  }

}
