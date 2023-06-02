//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2023. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication

/// Represents an authenticator that is listed and can be selected by the user on select authenticator view.
struct AuthenticatorItem {

	// MARK: - Properties

	/// The authenticator.
	let authenticator: any Authenticator

	/// Flag that tells whether the authenticator is policy compliant.
	let isPolicyCompliant: Bool

	/// Flag that tells whether the user already enrolled the authenticator.
	let isUserEnrolled: Bool

	/// Tells that whether this authenticator item is selectable on select authenticator view or not.
	/// The value is calculated based on the ``AuthenticatorItem/isPolicyCompliant`` and ``AuthenticatorItem/isUserEnrolled`` flags.
	var isEnabled: Bool {
		isPolicyCompliant && (authenticator.aaid == AuthenticatorAaid.Pin.rawValue || isUserEnrolled)
	}
}
