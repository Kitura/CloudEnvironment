import XCTest

import SwiftConfiguration
@testable import BluemixConfig


class FileLoadTests: XCTestCase {
    
    static var allTests : [(String, (FileLoadTests) -> () throws -> Void)] {
        return [
            ("testServiceGetters", testServiceGetters),
        ]
    }
    
    func testServiceGetters() {
        
        let manager = ConfigurationManager()
        
        do {
            // Modify relative path for your system, make more dynamic later
            try manager.load(file: "../../config_example.json", relativeFrom: "/Users/tlfrankl/ibm/ibm-swift/bluemix-config/.build/debug")
            
            let cloudantService = try manager.getCloudantService(name: "CloudantService")
            
            XCTAssertGreaterThan(cloudantService.host.characters.count, 0)
            XCTAssertGreaterThan(cloudantService.username.characters.count, 0)
            XCTAssertGreaterThan(cloudantService.password.characters.count, 0)
            XCTAssertNotEqual(cloudantService.port, 0)
            XCTAssertGreaterThan(cloudantService.url.characters.count, 0)
            
            let mongoDBService = try manager.getMongoDBService(name: "TodoList-MongoDB")
            
            XCTAssertGreaterThan(mongoDBService.host.characters.count, 0)
            XCTAssertGreaterThan(mongoDBService.username.characters.count, 0)
            XCTAssertGreaterThan(mongoDBService.password.characters.count, 0)
            XCTAssertNotEqual(mongoDBService.port, 0)
            XCTAssertGreaterThan(mongoDBService.certificate.characters.count, 0)

            let redisService = try manager.getRedisService(name: "RedisService")

            XCTAssertGreaterThan(redisService.host.characters.count, 0)
            XCTAssertGreaterThan(redisService.password.characters.count, 0)
            XCTAssertNotEqual(redisService.port, 0)
            
            let postgreSQLService = try manager.getPostgreSQLService(name: "TodoList-PostgreSQL")
            
            XCTAssertGreaterThan(postgreSQLService.host.characters.count, 0)
            XCTAssertGreaterThan(postgreSQLService.username.characters.count, 0)
            XCTAssertGreaterThan(postgreSQLService.password.characters.count, 0)
            XCTAssertNotEqual(postgreSQLService.port, 0)
            
            let mySQLService = try manager.getMySQLService(name: "TodoList-MySQL")
            
            XCTAssertGreaterThan(mySQLService.database.characters.count, 0)
            XCTAssertGreaterThan(mySQLService.host.characters.count, 0)
            XCTAssertGreaterThan(mySQLService.username.characters.count, 0)
            XCTAssertGreaterThan(mySQLService.password.characters.count, 0)
            XCTAssertNotEqual(mySQLService.port, 0)
            
            let db2Service = try manager.getDB2Service(name: "TodoList-DB2-Analytics")
            
            XCTAssertGreaterThan(db2Service.database.characters.count, 0)
            XCTAssertGreaterThan(db2Service.host.characters.count, 0)
            XCTAssertNotEqual(db2Service.port, 0)
            XCTAssertGreaterThan(db2Service.uid.characters.count, 0)
            XCTAssertGreaterThan(db2Service.pwd.characters.count, 0)
            
        } catch {
            XCTFail("Could not load configuration. Error: \(error)")
        }
        
    }
    
}
