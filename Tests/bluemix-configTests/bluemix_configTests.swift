import XCTest

import SwiftConfiguration
@testable import BluemixConfig


class bluemix_configTests: XCTestCase {
    func testExample() {
        
        let manager = ConfigurationManager()
        
        manager.loadBluemixService(type: .cloudant)
        
        let cloudantConfig = manager.getValue(for: "Bluemix:services:cloudant") as? BluemixService
        
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
