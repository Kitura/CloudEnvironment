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

class AutoScalingTests: XCTestCase {

    static var allTests : [(String, (AutoScalingTests) -> () throws -> Void)] {
        return [
            ("testGetCredentials", testGetCredentials),
        ]
    }

    func testGetCredentials() {

        // Load test mappings.json file and Cloud Foundry test credentials-- VCAP_SERVICES and VCAP_APPLICATION
        let cloudEnv = CloudEnv(mappingsFilePath: "Tests/CloudEnvironmentTests/resources", cloudFoundryFile: "Tests/CloudEnvironmentTests/resources/config_cf_example.json")

        guard let credentials =  cloudEnv.getAutoScalingCredentials(name: "AutoScalingKey") else {
            XCTFail("Could not load AutoScaling credentials.")
            return
        }

        XCTAssertEqual(credentials.url, "https://auto-scaling.ibm.com", "Auto-Scaling Service URL should match.")
        XCTAssertEqual(credentials.username, "21a084f4-4eb56-74547-3bdc7be5df9/d2a85740-da7a-4615-aabf-5bdc35c63618", "Auto-Scaling Service username should match.")
        XCTAssertEqual(credentials.password, "auto-scaling-pwd", "Auto-Scaling Service password should match.")
        XCTAssertEqual(credentials.appID, "auto-scaling-appID", "Auto-Scaling Service appID should match.")
        XCTAssertEqual(credentials.serviceID, "auto-scaling-serviceID", "Auto-Scaling Service serviceID should match.")
        XCTAssertEqual(credentials.apiURL, "https://auto-scaling.api.ibm.com", "Auto-Scaling Service apiURL should match.")


    }

}
