/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/. */

import Foundation

/// First simulator-only fork milestone: direct mail, without TabMail services.
enum PeopleMailMode {
    #if PEOPLE_MAIL_LOCAL
    static let isStandalone = true
    #else
    static let isStandalone = false
    #endif

    /// Fail closed for hosted-service requests, including accidental calls from
    /// upstream UI. The reserved .invalid domain cannot address a real service.
    /// This does not rewrite IMAP/SMTP providers or links in received messages.
    static func serviceURL(_ upstream: String) -> String {
        guard isStandalone else { return upstream }
        let scheme = upstream.hasPrefix("wss://") ? "wss" : "https"
        return "\(scheme)://disabled.people-mail.invalid"
    }
}
