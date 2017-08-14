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

/// CloudantCredentials class
///
/// Contains the credentials for a Cloudant service instance.
public class CloudantCredentials {

  public let host        : String
  public let username    : String
  public let password    : String
  public let port        : Int
  public let secured     : Bool
  public let url         : String

  public init?(username: String, password: String, url: String) {

    self.username   = username
    self.password   = password
    self.url        = url

    guard let scheme = CloudantCredentials.parseScheme(url: url) else {
      return nil
    }

    self.secured = (scheme == "https") ? true : false

    guard let host = CloudantCredentials.parseHost(url: url) else {
      return nil
    }

    guard let port = CloudantCredentials.parsePort(url: url) else {
      return nil
    }

    self.host = host
    self.port = port
  }

  private static func parseHost(url: String) -> String? {
    guard let parsedURL = URLComponents(string: url) else {
      return nil
    }
    return parsedURL.host
  }

  private static func parseScheme(url: String) -> String? {
    guard let parsedURL = URLComponents(string: url) else {
      return nil
    }

    guard let scheme = parsedURL.scheme else {
      return nil
    }

    return scheme.lowercased()
  }

  private static func parsePort(url: String) -> Int? {
    guard let parsedURL = URLComponents(string: url) else {
      return nil
    }

    if let port = parsedURL.port {
      return port
    }

    guard let scheme = parseScheme(url: url) else {
      return nil
    }

    return (scheme == "https") ? 443 : 80
  }

}

extension CloudEnv {

  /// Returns a CloudantCredentials object with the corresponding credentials.
  ///
  /// - Parameter name: The key to lookup the environment variable.
  public func getCloudantCredentials(name: String) -> CloudantCredentials? {
    guard let credentials = getDictionary(name: name),
    let username  = credentials["username"] as? String,
    let password  = credentials["password"] as? String,
    let url       = credentials["url"] as? String else {
      return nil
    }

    return CloudantCredentials (
      username: username,
      password: password,
      url: url
    )
  }

}
