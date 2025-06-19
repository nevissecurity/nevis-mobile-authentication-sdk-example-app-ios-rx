//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2024 Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication

/// Response class indicating the SDK operation asks for user verification using Password authenticator.
final class VerifyPasswordResponse: OperationResponse {

	// MARK: - Properties

	/// Status object of the Password authenticator.
	let protectionStatus: PasswordAuthenticatorProtectionStatus

	/// The object that is notified of the verification result.
	let handler: PasswordUserVerificationHandler

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameters:
	///   - protectionStatus: Status object of the Password authenticator.
	///   - handler: The object that is notified of the verification result.
	init(protectionStatus: PasswordAuthenticatorProtectionStatus,
	     handler: PasswordUserVerificationHandler) {
		self.protectionStatus = protectionStatus
		self.handler = handler
		super.init()
	}
}
