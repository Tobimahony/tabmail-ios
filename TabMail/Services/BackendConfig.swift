/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/. */

import Foundation

/// Centralized backend URL configuration.
/// ALL builds default to production endpoints — dev servers are an explicit
/// opt-in via Settings > Debug > "Use Dev Servers" toggle, persisted in
/// UserDefaults. Changing the toggle requires an app restart to take effect
/// for all services (Device Sync reconnects automatically).
enum BackendConfig {
    private static let devOverrideKey = "debug_use_dev_servers"

    /// Whether dev servers are active. Requires debug mode to be unlocked.
    /// When debug mode is locked, always returns false (production servers).
    ///
    /// The default is PROD even for DEBUG builds: unlocking the debug menu
    /// used to silently flip DEBUG builds to dev (`#if DEBUG` default-true),
    /// which broke `/demo/start` the moment the operator unlocked the menu to
    /// use demo recording — the dev environment's auth gate rejects the
    /// unauthenticated demo mint. Dev is now toggle-only (2026-07-02).
    static var useDevServers: Bool {
        get {
            guard UserDefaults.standard.bool(forKey: "debug_mode_unlocked") else { return false }
            return UserDefaults.standard.object(forKey: devOverrideKey) as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: devOverrideKey)
        }
    }

    static var apiBaseURL: URL {
        useDevServers
            ? URL(string: PeopleMailMode.serviceURL("https://dev.tabmail.ai"))!
            : URL(string: PeopleMailMode.serviceURL("https://api.tabmail.ai"))!
    }

    static var syncBaseURL: String {
        useDevServers ? PeopleMailMode.serviceURL("https://sync-dev.tabmail.ai") : PeopleMailMode.serviceURL("https://sync.tabmail.ai")
    }

    static var syncWebSocketURL: String {
        useDevServers ? PeopleMailMode.serviceURL("wss://sync-dev.tabmail.ai/ws") : PeopleMailMode.serviceURL("wss://sync.tabmail.ai/ws")
    }

    static var templatesBaseURL: URL {
        useDevServers
            ? URL(string: PeopleMailMode.serviceURL("https://templates-dev.tabmail.ai"))!
            : URL(string: PeopleMailMode.serviceURL("https://templates.tabmail.ai"))!
    }

    static var billingBaseURL: URL {
        useDevServers
            ? URL(string: PeopleMailMode.serviceURL("https://billing-dev.tabmail.ai"))!
            : URL(string: PeopleMailMode.serviceURL("https://billing.tabmail.ai"))!
    }

    /// The forms worker's public, anonymous trial-feedback endpoint (`TrialFeedback`).
    static var trialFeedbackURL: URL {
        useDevServers
            ? URL(string: PeopleMailMode.serviceURL("https://forms-dev.tabmail.ai/feedback/trial"))!
            : URL(string: PeopleMailMode.serviceURL("https://forms.tabmail.ai/feedback/trial"))!
    }

    static var appleWebhookBaseURL: URL {
        useDevServers
            ? URL(string: PeopleMailMode.serviceURL("https://apple-webhook-dev.tabmail.ai"))!
            : URL(string: PeopleMailMode.serviceURL("https://apple-webhook.tabmail.ai"))!
    }
}
