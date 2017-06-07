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

class WatsonConversationTests: XCTestCase {

    static var allTests : [(String, (WatsonConversationTests) -> () throws -> Void)] {
        return [
            ("testServiceGetters", testServiceGetters),
        ]
    }

    func testServiceGetters() {

        let manager = ConfigurationManager()

        // Modify relative path for your system, make more dynamic later
        let filePath = URL(fileURLWithPath: #file).appendingPathComponent("../config_example.json").standardized
        manager.load(url: filePath)

        guard let credentials =  manager.getWatsonConversationCredentials(name: "ConversationService") else {
            XCTFail("Could not load Watson Conversation service credentials.")
            return
        }

        XCTAssertGreaterThan(credentials.username.characters.count, 0)
        XCTAssertGreaterThan(credentials.password.characters.count, 0)
        XCTAssertGreaterThan(credentials.url.characters.count, 0)

    }

}
