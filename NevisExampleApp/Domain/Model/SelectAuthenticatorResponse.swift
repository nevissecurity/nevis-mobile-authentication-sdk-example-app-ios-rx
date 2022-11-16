//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication

/// Response class indicating the SDK operation asks the user to select one of the available authenticators.
final class SelectAuthenticatorResponse: OperationResponse {

	// MARK: - Properties

	/// The list of available authenticators.
	let authenticators: Set<Authenticator>

	/// The object that is notified of the selection result.
	let handler: AuthenticatorSelectionHandler

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameters:
	///   - authenticators: The list of available authenticators.
	///   - handler: The object that is notified of the selection result.
	init(authenticators: Set<Authenticator>,
	     handler: AuthenticatorSelectionHandler) {
		self.authenticators = authenticators
		self.handler = handler
		super.init()
	}
}
