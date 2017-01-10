import XCTest

import SwiftConfiguration
@testable import BluemixConfig


class bluemix_configTests: XCTestCase {
    func testExample() {
        
        let manager = ConfigurationManager()
        
        try? manager.loadFile("config.json").loadEnvironmentVariables()
        
        let cloudantConfig = manager.getService(type: .cloudant)
        
        if let cloudantConfig = cloudantConfig {
            XCTAssertNotNil(cloudantConfig)
        } else {
            fatalError()
        }
        
    }


    static var allTests : [(String, (bluemix_configTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
