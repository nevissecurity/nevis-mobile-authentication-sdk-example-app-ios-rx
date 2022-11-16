//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication

/// Response class indicating the SDK operation asks for enrolling the PIN authenticator.
final class EnrollPinResponse: OperationResponse {

	// MARK: - Properties

	/// The object describing the latest recoverable error (if any).
	var lastRecoverableError: PinEnrollmentError?

	/// The object that is notified of the enrollment result.
	let handler: PinEnrollmentHandler

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameters:
	///   - lastRecoverableError: The object describing the latest recoverable error (if any).
	///   - handler: The object that is notified of the enrollment result.
	init(lastRecoverableError: PinEnrollmentError?,
	     handler: PinEnrollmentHandler) {
		self.lastRecoverableError = lastRecoverableError
		self.handler = handler
		super.init()
	}
}
