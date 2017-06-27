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


public class AppConfiguration {

    let cloudFoundryManager = ConfigurationManager()
    let mapManager = ConfigurationManager()

    public init () {

        let mappingFile = "mapping.json"

        // For local mapping file
        mapManager.load(file: "config/\(mappingFile)", relativeFrom: .project)

        // For Cloud Foundry
        mapManager.load(file: mappingFile, relativeFrom: .pwd)
        mapManager.load(file: "config/\(mappingFile)", relativeFrom: .pwd)

    }

    public func getCredentials(name: String) -> [String:Any]? {

        guard let searchPatterns = mapManager["\(name):searchPatterns"] as? [String] else {
            Log.debug("No search patterns found. There may have been a problem loading `mapping.json`")
            return nil
        }

        for pattern in searchPatterns {

            var arr = pattern.components(separatedBy: ":")

            let key = arr.removeFirst()
            let value = arr.removeFirst()

            switch (key) {
            case "cloudfoundry":    // CloudFoundry/swift-cfenv
                if let credentials = getCloudFoundryCreds(name: value) {
                    Log.debug("Found cloud foundry credentials.")
                    return credentials
                }
                break
            case "env":             // Kubernetes
                if let credentials = getKubeCreds(evName: value) {
                    Log.debug("Found credentials from environment variable.")
                    return credentials
                }
                break
            case "file":            // File- local or in cloud foundry
                let instance = (arr.count > 0) ? arr[0] : ""

                if let credentials = getLocalCreds(instance: instance, path: value),
                    credentials.count > 0 {
                    Log.debug("Found credentials in referenced file.")
                    return credentials
                }
                break
            default:
                return nil
            }

        }
        Log.error("Failed to find credentials.")
        return nil
    }

    private func getCloudFoundryCreds(name: String) -> [String:Any]? {

        cloudFoundryManager.load(.environmentVariables)

        guard let credentials = cloudFoundryManager.getServiceCreds(spec: name) else {
            return nil
        }

        return credentials
    }

    private func getKubeCreds(evName: String) -> [String:Any]? {

        let kubeManager = ConfigurationManager()
        kubeManager.load(.environmentVariables)

        guard let credentials = kubeManager["\(evName)"] as? [String: Any] else {
            return nil
        }

        return credentials
    }

    private func getLocalCreds(instance: String, path: String) -> [String:Any]? {

        let fileManager = ConfigurationManager()

        // For local mapping file
        fileManager.load(file: path, relativeFrom: .project)

        // Load file in cloud foundry-- extract filename from path
        if let fileName = path.components(separatedBy: "/").last {
            fileManager.load(file: fileName, relativeFrom: .pwd)
        }

        if instance == "" {
            return (fileManager.getConfigs() as? [String: Any])
        }
        else {
            return fileManager["\(instance)"] as? [String: Any]
        }
    }

    // Used internally for testing purposes
    internal func loadCFTestConfigs(path: String) {

        cloudFoundryManager.load(file: path, relativeFrom: .project)
    }
    
    // Used internally for testing purposes
    internal func loadMappingTestConfigs(path: String) {
        
        mapManager.load(file: path, relativeFrom: .project)
    }
}

