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

class PushSDKTests: XCTestCase {

    static var allTests : [(String, (PushSDKTests) -> () throws -> Void)] {
        return [
            ("testGetCredentials", testGetCredentials),
        ]
    }

    func testGetCredentials() {

        let manager = ConfigurationManager()

        // Modify relative path for your system, make more dynamic later
        let filePath = URL(fileURLWithPath: #file).appendingPathComponent("../config_example.json").standardized
        manager.load(url: filePath)

        guard let credentials =  manager.getPushSDKCredentials(name: "PushNotificationService") else {
            XCTFail("Could not load Push SDK credentials.")
            return
        }

        XCTAssertEqual(credentials.appGuid, "<appGuid>", "PushSDK service appGuid should match.")
        XCTAssertEqual(credentials.url, "http://imfpush.ng.bluemix.net/imfpush/v1", "PushSDK service url should match.")
        XCTAssertEqual(credentials.admin_url, "//mobile.ng.bluemix.net/imfpushdashboard", "PushSDK service admin_url should match.")
        XCTAssertEqual(credentials.appSecret, "<appSecret>", "PushSDK service appSecret should match.")
        XCTAssertEqual(credentials.clientSecret, "<clientSecret>", "PushSDK service clientSecret should match.")
        
    }
    
}
