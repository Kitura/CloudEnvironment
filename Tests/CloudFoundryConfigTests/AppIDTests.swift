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
import Foundation
import Configuration
@testable import CloudFoundryConfig

class AppIDTests: XCTestCase {

    static var allTests : [(String, (AppIDTests) -> () throws -> Void)] {
        return [
            ("testGetCredentials", testGetCredentials),
        ]
    }

    func testGetCredentials() {

        let manager = ConfigurationManager()


        // Modify relative path for your system, make more dynamic later
        let filePath = URL(fileURLWithPath: #file).appendingPathComponent("../config_example.json").standardized
        manager.load(url: filePath)

        guard let credentials =  manager.getAppIDCredentials(name: "AppIDService") else {
            XCTFail("Could not load AppID credentials.")
            return
        }

        XCTAssertEqual(credentials.clientId, "<clientId>", "AppID Service clientId should match.")
        XCTAssertEqual(credentials.oauthServerUrl, "https://appid-oauth.stage1.ng.bluemix.net/oauth/v3/ee971e31-eb19-415b-af84-45172c24895c", "AppID oauthServerUrl should match.")
        XCTAssertEqual(credentials.profilesUrl, "https://appid-profiles.stage1.ng.bluemix.net", "AppID Service profilesUrl should match.")
        XCTAssertEqual(credentials.secret, "<secret>", "AppID Service secret should match.")
        XCTAssertEqual(credentials.tenantId, "ee971e31-eb19-415b-af84-45172c24895c", "AppID Service tenantId should match.")
        XCTAssertEqual(credentials.version, 3, "AppID Service version should match.")
        
    }
    
}