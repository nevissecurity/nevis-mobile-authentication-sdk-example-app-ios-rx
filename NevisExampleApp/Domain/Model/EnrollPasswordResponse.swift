//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2024 Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication

/// Response class indicating the SDK operation asks for enrolling the Password authenticator.
final class EnrollPasswordResponse: OperationResponse {

	// MARK: - Properties

	/// The object describing the latest recoverable error (if any).
	var lastRecoverableError: PasswordEnrollmentError?

	/// The object that is notified of the enrollment result.
	let handler: PasswordEnrollmentHandler

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameters:
	///   - lastRecoverableError: The object describing the latest recoverable error (if any).
	///   - handler: The object that is notified of the enrollment result.
	init(lastRecoverableError: PasswordEnrollmentError?,
	     handler: PasswordEnrollmentHandler) {
		self.lastRecoverableError = lastRecoverableError
		self.handler = handler
		super.init()
	}
}
