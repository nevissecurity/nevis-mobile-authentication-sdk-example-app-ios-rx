//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2024 Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication

/// Response class indicating the SDK operation asks for user verification using a biometric authenticator.
final class VerifyBiometricResponse: OperationResponse {

	// MARK: - Properties

	/// The selected authenticator.
	let authenticator: String

	/// The object that is notified of the verification result.
	let handler: BiometricUserVerificationHandler

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameters:
	///   - authenticator: The selected authenticator.
	///   - handler: The object that is notified of the verification result.
	init(authenticator: String,
	     handler: BiometricUserVerificationHandler) {
		self.authenticator = authenticator
		self.handler = handler
		super.init()
	}
}
