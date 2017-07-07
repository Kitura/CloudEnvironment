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
@testable import CloudConfigurationTests

XCTMain([
    testCase(AlertNotificationTests.allTests),
    testCase(AppIDTests.allTests),
    testCase(AutoScalingTests.allTests),
    testCase(CloudantTests.allTests),
    testCase(DB2Tests.allTests),
    testCase(MongoDBTests.allTests),
    testCase(MySQLTests.allTests),
    testCase(ObjectStorageTests.allTests),
    testCase(PostgreSQLTests.allTests),
    testCase(PushSDKTests.allTests),
    testCase(RedisTests.allTests),
    testCase(WatsonConversationTests.allTests),
    testCase(NaturalLangUnderstandingTests.allTests),
    testCase(WeatherCompanyDataTests.allTests),
    testCase(EnvironmentVariablesTests.allTests),
    testCase(LocalFileTests.allTests)
    ])
