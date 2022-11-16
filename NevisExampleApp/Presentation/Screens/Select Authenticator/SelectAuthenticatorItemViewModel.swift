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

	/// The readable details.
	let details: String

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameters:
	///   - title: The readable title.
	///   - details: The readable details.
	init(authenticator: Authenticator) {
		self.title = authenticator.localizedTitle
		self.details = authenticator.localizedDescription
	}
}
