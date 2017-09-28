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

class BaseTest: XCTestCase {

    var resourcesFolder: String!
    var cloudFoundryFile: String!

    override func setUp() {
        super.setUp()
        let thisFile = #file

        guard let range = thisFile.range(of: "/", options: .backwards) else {
           XCTFail("Could not determine path for configuraton file.")
           return
        }

        resourcesFolder = String(thisFile[..<range.lowerBound] + "/resources")
        cloudFoundryFile = resourcesFolder + "/config_cf_example.json"
    }

    func getAbsolutePath(forResource resource: String) -> String {
        return resourcesFolder + "/" + resource
    }
    
}
