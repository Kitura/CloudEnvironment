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
            let filePath = URL(fileURLWithPath: #file).appendingPathComponent("../config_example.json").standardized
            manager.load(url: filePath)

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

            let alertNotificationService = try manager.getAlertNotificationService(name: "IBM Alert Notification-xs")

            XCTAssertEqual(alertNotificationService.url, "https://ibmnotifybm.mybluemix.net/api/alerts/v1", "Alert Notification Service URL should match.")
            XCTAssertEqual(alertNotificationService.id, "21a084f4-4eb3-4de4-9834-33bdc7be5df9/d2a85740-da7a-4615-aabf-5bdc35c63618", "Alert Notification Service ID should match.")
            XCTAssertEqual(alertNotificationService.password, "alertnotification-pwd", "Alert Notification Service password should match.")
            XCTAssertEqual(alertNotificationService.swaggerUI, "https://ibmnotifybm.mybluemix.net/docs/alerts/v1", "Alert Notification Service swaggerUI should match.")

            let autoScalingService = try manager.getAutoScalingService(name: "IBM Auto Scaling-xs")

            XCTAssertEqual(autoScalingService.url, "https://auto-scaling.ibm.com", "Auto-Scaling Service URL should match.")
            XCTAssertEqual(autoScalingService.username, "21a084f4-4eb56-74547-3bdc7be5df9/d2a85740-da7a-4615-aabf-5bdc35c63618", "Auto-Scaling Service username should match.")
            XCTAssertEqual(autoScalingService.password, "auto-scaling-pwd", "Auto-Scaling Service password should match.")
            XCTAssertEqual(autoScalingService.appID, "auto-scaling-appID", "Auto-Scaling Service appID should match.")
            XCTAssertEqual(autoScalingService.serviceID, "auto-scaling-serviceID", "Auto-Scaling Service serviceID should match.")
            XCTAssertEqual(autoScalingService.apiURL, "https://auto-scaling.api.ibm.com", "Auto-Scaling Service apiURL should match.")

            let appIDService = try manager.getAppIDService(name: "App ID-qt")

            XCTAssertEqual(appIDService.clientId, "<clientId>", "AppID Service clientId should match.")
            XCTAssertEqual(appIDService.oauthServerUrl, "https://appid-oauth.stage1.ng.bluemix.net/oauth/v3/ee971e31-eb19-415b-af84-45172c24895c", "AppID oauthServerUrl should match.")
            XCTAssertEqual(appIDService.profilesUrl, "https://appid-profiles.stage1.ng.bluemix.net", "AppID Service profilesUrl should match.")
            XCTAssertEqual(appIDService.secret, "<secret>", "AppID Service secret should match.")
            XCTAssertEqual(appIDService.tenantId, "ee971e31-eb19-415b-af84-45172c24895c", "AppID Service tenantId should match.")
            XCTAssertEqual(appIDService.version, 3, "AppID Service version should match.")
            
            let conversationService = try manager.getWatsonConversationService(name: "ConversationService")
            
            XCTAssertGreaterThan(conversationService.username.characters.count, 0)
            XCTAssertGreaterThan(conversationService.password.characters.count, 0)
            XCTAssertGreaterThan(conversationService.url.characters.count, 0)
            
            let pushSDKService = try manager.getPushSDKService(name: "PushNotificationService")

            XCTAssertEqual(pushSDKService.appGuid, "<appGuid>", "PushSDK Service appGuid should match.")
            XCTAssertEqual(pushSDKService.url, "http://imfpush.ng.bluemix.net/imfpush/v1", "PushSDK Service url should match.")
            XCTAssertEqual(pushSDKService.admin_url, "//mobile.ng.bluemix.net/imfpushdashboard", "PushSDK Service admin_url should match.")
            XCTAssertEqual(pushSDKService.appSecret, "<appSecret>", "PushSDK Service appSecret should match.")
            XCTAssertEqual(pushSDKService.clientSecret, "<clientSecret>", "PushSDK Service clientSecret should match.")
            
            let nluService = try manager.getNaturalLanguageUnderstandingService(name: "NLUService")
            
            XCTAssertGreaterThan(nluService.username.characters.count, 0)
            XCTAssertGreaterThan(nluService.password.characters.count, 0)
            XCTAssertGreaterThan(nluService.url.characters.count, 0)
            
        } catch {
            XCTFail("Could not load configuration. Error: \(error)")
        }
    }
    
}
