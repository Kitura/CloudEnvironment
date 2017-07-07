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

class WeatherCompanyDataTests: XCTestCase {

    static var allTests : [(String, (WeatherCompanyDataTests) -> () throws -> Void)] {
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

        guard let credentials =  manager.getWeatherCompanyDataCredentials(name: "WeatherCompanyDataKey") else {
            XCTFail("Could not load Weather Company Data service credentials.")
            return
        }

        XCTAssertEqual(credentials.username, "<username>", "Weather Company Data service username should match.")
        XCTAssertEqual(credentials.password, "<password>", "Weather Company Data service password should match.")
        XCTAssertEqual(credentials.host, "<host>", "Weather Company Data service host should match.")
        XCTAssertEqual(credentials.port, 443, "Weather Company Data service port should match.")
        XCTAssertEqual(credentials.url, "<url>", "Weather Company Data service url should match.")
        
    }
    
}
