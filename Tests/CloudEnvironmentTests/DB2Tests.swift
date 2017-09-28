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

class DB2Tests: BaseTest {

    static var allTests : [(String, (DB2Tests) -> () throws -> Void)] {
        return [
            ("testGetCredentials", testGetCredentials),
        ]
    }

    func testGetCredentials() {

        // Load test mappings.json file and Cloud Foundry test credentials-- VCAP_SERVICES and VCAP_APPLICATION
        let cloudEnv = CloudEnv(mappingsFileFolder: resourcesFolder, cloudFoundryFile: cloudFoundryFile)

        guard let credentials =  cloudEnv.getDB2Credentials(name: "DB2Key") else {
            XCTFail("Could not load DB2 service credentials.")
            return
        }

        XCTAssertEqual(credentials.database, "BLUDB", "DB2 service database should match.")
        XCTAssertEqual(credentials.host, "dashdb-entry-yp-dal09-07.services.dal.bluemix.net", "DB2 service host should match.")
        XCTAssertEqual(credentials.port, 50000, "DB2 service port should match.")
        XCTAssertEqual(credentials.uid, "uid", "DB2 service uid should match.")
        XCTAssertEqual(credentials.pwd, "pwd", "DB2 service pwd should match.")

    }

}
