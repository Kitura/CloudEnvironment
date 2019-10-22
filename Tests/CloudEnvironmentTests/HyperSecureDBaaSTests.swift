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

import XCTest
import Configuration
@testable import CloudEnvironment

class HyperProtectDBaaSTests: XCTestCase {

    static var allTests : [(String, (HyperProtectDBaaSTests) -> () throws -> Void)] {
        return [
            ("testGetCredentials", testGetCredentials),
        ]
    }

    func testGetCredentials() {

        // Load test mappings.json file and Cloud Foundry test credentials-- VCAP_SERVICES and VCAP_APPLICATION
        let cloudEnv = CloudEnv(mappingsFilePath: "Tests/CloudEnvironmentTests/resources", cloudFoundryFile: "Tests/CloudEnvironmentTests/resources/config_cf_example.json")

        guard let credentials =  cloudEnv.getHyperProtectDBaaSCredentials(name: "HyperProtectDBaaS") else {
            XCTFail("Could not load HyperSercureDBaaS credentials.")
            return
        }

        // Comment until new HP DBaaS added
        //XCTAssertEqual(credentials.password, "199b3db8be4c4b2baeb0b460f6e3fa20", "HypersercureDBaaS service password should match.")
        //XCTAssertEqual(credentials.cert, "-----BEGIN CERTIFICATE-----\nMIIDrzCCApegAwIBAgIQCDvgVpBCRrGhdWrJWZHHSjANBgkqhkiG9w0BAQUFADBh\n-----END CERTIFICATE-----\n", "HypersercureDBaaS service cert should match.")
        //XCTAssertEqual(credentials.username, "7f49ed06-d822-426f-bda6-76a515884450", "HypersercureDBaaS service port should match.")
        //XCTAssertEqual(credentials.uri, "mongodb://7f49ed06-d822-426f-bda6-76a515884450:199b3db8be4c4b2baeb0b460f6e3fa20@dbaas08.hyperp-dbaas.ibm.com:20489,dbaas10.hyperp-dbaas.ibm.com:20553,dbaas09.hyperp-dbaas.ibm.com:20229/7f49ed06-d822-426f-bda6-76a515884450?replicaSet=testerclus", "HypersercureDBaaS service uri should match.")

    }

}
