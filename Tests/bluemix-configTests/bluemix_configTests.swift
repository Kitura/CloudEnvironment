import XCTest
@testable import bluemix_config

class bluemix_configTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(bluemix_config().text, "Hello, World!")
    }


    static var allTests : [(String, (bluemix_configTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
