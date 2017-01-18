import XCTest

import SwiftConfiguration
@testable import BluemixConfig


class bluemix_configTests: XCTestCase {
    func testExample() {
        
        let manager = ConfigurationManager()
        
        do {
            manager.load(.environmentVariables).load("../../config.json")
            
            let cloudantService = try manager.getCloudantService(name: "CloudantService")
            
            XCTAssertNotNil(cloudantService)
         
        } catch {
            XCTAssertTrue(true, "Could not load configuration")
        }
        
    }
    
    
    static var allTests : [(String, (bluemix_configTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
