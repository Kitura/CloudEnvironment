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

/// Credentials class
///
/// Contains a basic common set of credential elements.
public class Credentials {
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

    guard let scheme = Credentials.parseScheme(url: url) else {
      return nil
    }

    self.secured = (scheme == "https") ? true : false

    guard let host = Credentials.parseHost(url: url) else {
      return nil
    }

    guard let port = Credentials.parsePort(url: url) else {
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
