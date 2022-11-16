//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication

/// Response class indicating the SDK operation asks for user verification using PIN authenticator.
final class ChangePinResponse: OperationResponse {

	// MARK: - Properties

	/// Status object of the PIN authenticator.
	let protectionStatus: PinAuthenticatorProtectionStatus

	/// The object describing the last credential verification error.
	let lastRecoverableError: PinChangeRecoverableError?

	/// The object that is notified of the change result.
	let handler: PinChangeHandler

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameters:
	///   - protectionStatus: Status object of the PIN authenticator.
	///   - lastRecoverableError: The object describing the last credential verification error.
	///   - handler: The object that is notified of the change result.
	init(protectionStatus: PinAuthenticatorProtectionStatus,
	     lastRecoverableError: PinChangeRecoverableError?,
	     handler: PinChangeHandler) {
		self.protectionStatus = protectionStatus
		self.lastRecoverableError = lastRecoverableError
		self.handler = handler
		super.init()
	}
}
