//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2024 Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication

/// Response class indicating the SDK operation asks for user verification using Password authenticator.
final class ChangePasswordResponse: OperationResponse {

	// MARK: - Properties

	/// Status object of the Password authenticator.
	let protectionStatus: PasswordAuthenticatorProtectionStatus

	/// The object describing the last credential verification error.
	let lastRecoverableError: PasswordChangeRecoverableError?

	/// The object that is notified of the change result.
	let handler: PasswordChangeHandler

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameters:
	///   - protectionStatus: Status object of the Password authenticator.
	///   - lastRecoverableError: The object describing the last credential verification error.
	///   - handler: The object that is notified of the change result.
	init(protectionStatus: PasswordAuthenticatorProtectionStatus,
	     lastRecoverableError: PasswordChangeRecoverableError?,
	     handler: PasswordChangeHandler) {
		self.protectionStatus = protectionStatus
		self.lastRecoverableError = lastRecoverableError
		self.handler = handler
		super.init()
	}
}
