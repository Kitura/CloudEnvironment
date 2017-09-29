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

import XCTest
import Configuration
@testable import CloudEnvironment

class EnvironmentVariablesTests: XCTestCase {

    static var allTests : [(String, (EnvironmentVariablesTests) -> () throws -> Void)] {
        return [
            ("testGetCredentials", testGetCredentials),
        ]
    }

    func testGetCredentials() {

        // Load test mappings.json file
        let cloudEnv = CloudEnv(mappingsFilePath: "Tests/CloudEnvironmentTests/resources")

        let jsonString = "{\"name\":\"21a084f4-4eb3-4de4-9834-33bdc7be5df9/d2a85740-da7a-4615-aabf-5bdc35c63618\",\"password\":\"alertnotification-pwd\",\"url\":\"https://ibmnotifybm.mybluemix.net/api/alerts/v1\",\"swaggerui\":\"https://ibmnotifybm.mybluemix.net/docs/alerts/v1\"}"

        guard let json = convertToDictionary(text: jsonString),
            let testUrl         = json["url"] as? String,
            let testName        = json["name"] as? String,
            let testPassword    = json["password"] as? String else {

                XCTFail("Loading test values failure.")
                return
        }

        #if os(macOS)
            // Set environment variable. Does not work in Linux yet due to https://bugs.swift.org/browse/SR-5076
            XCTAssertEqual(setenv("KUBE_ENV", jsonString, 1), 0)

            guard let credentials =  cloudEnv.getAlertNotificationCredentials(name: "AlertNotificationEVKey") else {
                XCTFail("Could not load Alert Notification service credentials.")
                return
            }

            XCTAssertEqual(credentials.url, testUrl, "Alert Notification Service URL should match.")
            XCTAssertEqual(credentials.name, testName, "Alert Notification Service name should match.")
            XCTAssertEqual(credentials.password, testPassword, "Alert Notification Service password should match.")

            // Unset env var
            XCTAssertEqual(unsetenv("KUBE_ENV"), 0)
        #endif

    }

    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }

}
