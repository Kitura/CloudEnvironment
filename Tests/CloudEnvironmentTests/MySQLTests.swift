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

class MySQLTests: BaseTest {

    static var allTests : [(String, (MySQLTests) -> () throws -> Void)] {
        return [
            ("testGetCredentials", testGetCredentials),
        ]
    }

    func testGetCredentials() {

        // Load test mappings.json file and Cloud Foundry test credentials-- VCAP_SERVICES and VCAP_APPLICATION
        let cloudEnv = CloudEnv(mappingsFileFolder: resourcesFolder, cloudFoundryFile: cloudFoundryFile)

        guard let credentials =  cloudEnv.getMySQLCredentials(name: "MySQLKey") else {
            XCTFail("Could not load MySQL credentials.")
            return
        }

        XCTAssertEqual(credentials.database, "ad_59567cc9d4432b9", "MySQL service database should match.")
        XCTAssertEqual(credentials.host, "us-cdbr-iron-east-04.cleardb.net", "MySQL service host should match.")
        XCTAssertEqual(credentials.username, "username", "MySQL service username should match.")
        XCTAssertEqual(credentials.password, "password", "MySQL service password should match.")
        XCTAssertEqual(credentials.port, 3306, "MySQL service port should match.")

    }

}
