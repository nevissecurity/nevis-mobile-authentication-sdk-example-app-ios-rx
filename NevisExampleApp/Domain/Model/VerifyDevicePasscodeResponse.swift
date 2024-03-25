//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2024 Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication

/// Response class indicating the SDK operation asks for user verification using the device passcode authenticator.
final class VerifyDevicePasscodeResponse: OperationResponse {

	// MARK: - Properties

	/// The selected authenticator.
	let authenticator: String

	/// The object that is notified of the verification result.
	let handler: DevicePasscodeUserVerificationHandler

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameters:
	///   - authenticator: The selected authenticator.
	///   - handler: The object that is notified of the verification result.
	init(authenticator: String,
	     handler: DevicePasscodeUserVerificationHandler) {
		self.authenticator = authenticator
		self.handler = handler
		super.init()
	}
}
