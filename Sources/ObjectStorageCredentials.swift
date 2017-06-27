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

/// Contains the credentials for an Object Storage service instance
public class ObjectStorageCredentials {

    public let authURL:     String
    public let project:     String
    public let projectID:   String
    public let region:      String
    public let userID:      String
    public let username:    String
    public let password:    String
    public let domainID:    String
    public let domainName:  String
    public let role:        String

    public init (
        authURL:    String,
        project:    String,
        projectID:  String,
        region:     String,
        userID:     String,
        username:   String,
        password:   String,
        domainID:   String,
        domainName: String,
        role:       String ){

        self.authURL    = authURL
        self.project    = project
        self.projectID  = projectID
        self.region     = region
        self.userID     = userID
        self.username   = username
        self.password   = password
        self.domainID   = domainID
        self.domainName = domainName
        self.role       = role

    }
}

extension AppConfiguration {

    public func getObjectStorageCredentials (name: String) -> ObjectStorageCredentials? {

        guard let credentials = getCredentials(name: name),
            let authURL     = credentials["auth_url"] as? String,
            let project     = credentials["project"] as? String,
            let projectID   = credentials["projectId"] as? String,
            let region      = credentials["region"] as? String,
            let userID      = credentials["userId"] as? String,
            let username    = credentials["username"] as? String,
            let password    = credentials["password"] as? String,
            let domainID    = credentials["domainId"] as? String,
            let domainName  = credentials["domainName"] as? String,
            let role        = credentials["role"] as? String else {

                return nil
        }

        return ObjectStorageCredentials (
            authURL:    authURL,
            project:    project,
            projectID:  projectID,
            region:     region,
            userID:     userID,
            username:   username,
            password:   password,
            domainID:   domainID,
            domainName: domainName,
            role:       role )
        
    }
    
}
