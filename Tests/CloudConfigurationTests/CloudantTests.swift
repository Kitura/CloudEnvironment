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
@testable import CloudConfiguration

class CloudantTests: XCTestCase {

    static var allTests : [(String, (CloudantTests) -> () throws -> Void)] {
        return [
            ("testGetCredentials", testGetCredentials),
        ]
    }

    func testGetCredentials() {

        let manager = AppConfiguration()

        // Load test mapping.json file
        manager.loadMappingTestConfigs(path: "Tests/ConfigTests/mapping.json")

        // Load Cloud Foundry test credentials-- VCAP_SERVICES and VCAP_APPLICATION
        manager.loadCFTestConfigs(path: "Tests/ConfigTests/config_cf_example.json")

        guard let credentials =  manager.getCloudantCredentials(name: "CloudantKey") else {
            XCTFail("Could not load Cloudant credentials.")
            return
        }

        XCTAssertEqual(credentials.host, "<host>", "Cloudant service host should match.")
        XCTAssertEqual(credentials.username, "<username>", "Cloudant service username should match.")
        XCTAssertEqual(credentials.password, "<password>", "Cloudant service password should match.")
        XCTAssertEqual(credentials.port, 443, "Cloudant service port should match.")
        XCTAssertEqual(credentials.url, "<url>", "Cloudant service URL should match.")

    }
    
}
