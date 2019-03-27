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

/// Contains a basic common set of credential elements.
public class Credentials {
  /// The host name.
  public let host        : String
  /// The username.
  public let username    : String
  /// The password.
  public let password    : String
  /// The port.
  public let port        : Int
  /// Indicates whether the credentials are secured or not.
  public let secured     : Bool
  /// The URL.
  public let url         : String

  /// Initalizes an instance of `Credentials`.
  public init?(username: String? = nil, password: String? = nil, url: String) {

    self.url = url
    guard let user = username ?? Credentials.parseUsername(url: url) else {
      return nil
    }
    self.username = user

    guard let pwd = password ?? Credentials.parsePassword(url: url) else {
      return nil
    }
    self.password = pwd

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

   private static func parseUsername(url: String) -> String? {
    guard let parsedURL = URLComponents(string: url) else {
      return nil
    }

    guard let username = parsedURL.user else {
      return nil
    }

    return username
  }

   private static func parsePassword(url: String) -> String? {
    guard let parsedURL = URLComponents(string: url) else {
      return nil
    }

    guard let password = parsedURL.password else {
      return nil
    }

    return password
  }

}
