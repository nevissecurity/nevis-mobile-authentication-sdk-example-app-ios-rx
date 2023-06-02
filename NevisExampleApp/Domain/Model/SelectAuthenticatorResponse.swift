//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication

/// Response class indicating the SDK operation asks the user to select one of the available authenticators.
final class SelectAuthenticatorResponse: OperationResponse {

	// MARK: - Properties

	/// The list of authenticator items.
	let authenticatorItems: [AuthenticatorItem]

	/// The object that is notified of the selection result.
	let handler: AuthenticatorSelectionHandler

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameters:
	///   - authenticatorItems: The list of authenticator items.
	///   - handler: The object that is notified of the selection result.
	init(authenticatorItems: [AuthenticatorItem],
	     handler: AuthenticatorSelectionHandler) {
		self.authenticatorItems = authenticatorItems
		self.handler = handler
		super.init()
	}
}
