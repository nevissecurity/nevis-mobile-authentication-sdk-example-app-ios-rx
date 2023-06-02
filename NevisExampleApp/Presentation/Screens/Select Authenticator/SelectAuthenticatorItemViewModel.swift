//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication

/// View model of a cell that displaying information about an available authenticator.
struct SelectAuthenticatorItemViewModel {

	// MARK: - Properties

	/// The readable title.
	let title: String

	/// Flag that tells whether the item is selectable.
	let isEnabled: Bool

	/// The readable details.
	var details: String?

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameter authenticatorItem: The authenticator item.
	init(item: AuthenticatorItem) {
		self.title = item.authenticator.localizedTitle
		self.isEnabled = item.isEnabled
		guard !item.isEnabled else {
			return
		}

		if !item.isPolicyCompliant {
			self.details = L10n.AuthenticatorSelection.authenticatorNotPolicyCompliant
		}
		if !item.isUserEnrolled {
			self.details = L10n.AuthenticatorSelection.authenticatorNotEnrolled
		}
	}
}
