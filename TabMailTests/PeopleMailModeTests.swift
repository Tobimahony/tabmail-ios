/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/. */

import XCTest
@testable import TabMail

final class PeopleMailModeTests: XCTestCase {
    func testHostedEndpointsCannotReachTabMailInStandaloneBuild() throws {
        guard PeopleMailMode.isStandalone else { throw XCTSkip("Standalone build only") }
        let endpoints = [
            BackendConfig.apiBaseURL.absoluteString,
            BackendConfig.syncBaseURL,
            BackendConfig.syncWebSocketURL,
            BackendConfig.templatesBaseURL.absoluteString,
            BackendConfig.billingBaseURL.absoluteString,
            BackendConfig.trialFeedbackURL.absoluteString,
            BackendConfig.appleWebhookBaseURL.absoluteString,
            PushConfig.baseURL
        ]
        for endpoint in endpoints {
            XCTAssertEqual(URL(string: endpoint)?.host, "disabled.people-mail.invalid")
        }
    }

    func testStandaloneDoesNotReuseAnUpstreamSession() throws {
        guard PeopleMailMode.isStandalone else { throw XCTSkip("Standalone build only") }
        XCTAssertFalse(TabMailAuthService.hasSession())
    }
}
