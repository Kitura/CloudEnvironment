/*
 * Copyright IBM Corporation 2018
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
import Logging

extension Collection where Element: Equatable {
    func indexDistance(of element: Element) -> Int? {
        guard let index = firstIndex(of: element) else { return nil }
        return distance(from: startIndex, to: index)
    }
}
extension StringProtocol {
    func indexDistance<S: StringProtocol>(of string: S) -> Int? {
        guard let index = range(of: string)?.lowerBound else { return nil }
        return distance(from: startIndex, to: index)
    }
}

/// Contains the credentials for a HyperProtectDBaaS service instance. You will typically
/// receive an instance of this type through `cloudEnv.getHyperProtectDBaaSCredentials(name: String)`.
///
/// Reference [Hyper Protect DBaaS](https://cloud.ibm.com/catalog/services/hyper-protect-dbaas).
public class HyperProtectDBaaSCredentials {
    
    /// The URI from the Hyper Protext DBaaS service instance credentials.
    public let uri: String
    /// The certificate from the Hyper Protext DBaaS service instance credentials.
    public let cert: String
    /// The username from the Hyper Protext DBaaS service instance credentials.
    public let username: String
    /// The password from the Hyper Protext DBaaS service instance credentials.
    public let password: String
    /// The db name from the Hyper Protext DBaaS service instance credentials.
    public let db: String
    
    /// Initializes an instance of the Hyper Protext DBaaS service credentials.
    public init(
        uri: String,
        cert: String,
        username: String,
        password: String,
        db: String) {
        
        self.uri = uri
        self.cert = cert
        self.username = username
        self.password = password
        self.db = db
    }
}

extension CloudEnv {
    
    /// Returns a HyperProtectDBaaSCredentials object with the corresponding credentials.
    ///
    /// ### Usage Example: ###
    /// ```swift
    /// let cloudEnv = CloudEnv()
    ///
    /// credentials =  cloudEnv.getHyperProtectDBaaSCredentials(name: "HyperProtectDBaaSKey")
    /// ```
    /// - Parameter name: The key to lookup the credentials object.
    public func getHyperProtectDBaaSCredentials(name: String) -> HyperProtectDBaaSCredentials? {
        
        guard let credentials = getDictionary(name: name) else {
            return nil
        }
        
        guard let uri = credentials["uri"] as? String,
            let cert = credentials["cert"] as? String,
            let username = credentials["username"] as? String,
            let password = credentials["password"] as? String,
            let db = credentials["db"] as? String else {
                return nil
        }

        let mongo_tag = "mongodb://";

        // check if mixed/illegal uri
        if (!uri.contains("mongodb://")) { print("URI must be of format mongodb://..."); return nil }

        // check if mixed/illegal uri
        if (uri.contains("@")) { print("URI containers username/password"); return nil }

        // HPDBaaS doesn't accept params. SSL is the default and only supported option.
        if (uri.contains("&")) { print("No paramerets accepted"); return nil }
        
        return HyperProtectDBaaSCredentials(
            uri: uri.replacingOccurrences(of: mongo_tag, with: ""),
            cert: cert,
            username: username,
            password: password,
            db: db)
    }
}
