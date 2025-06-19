//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication

/// Response class indicating the SDK operation asks for user verification using PIN authenticator.
final class VerifyPinResponse: OperationResponse {

	// MARK: - Properties

	/// Status object of the PIN authenticator.
	let protectionStatus: PinAuthenticatorProtectionStatus

	/// The object that is notified of the verification result.
	let handler: PinUserVerificationHandler

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameters:
	///   - protectionStatus: Status object of the PIN authenticator.
	///   - handler: The object that is notified of the verification result.
	init(protectionStatus: PinAuthenticatorProtectionStatus,
	     handler: PinUserVerificationHandler) {
		self.protectionStatus = protectionStatus
		self.handler = handler
		super.init()
	}
}
