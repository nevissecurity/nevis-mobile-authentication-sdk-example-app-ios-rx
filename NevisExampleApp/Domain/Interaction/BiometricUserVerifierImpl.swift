//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication

/// Default implementation of ``BiometricUserVerifier`` protocol.
///
/// With the help of the ``ResponseEmitter`` it will emit a ``VerifyFaceIdResponse``.
class BiometricUserVerifierImpl {

	// MARK: - Properties

	/// The logger.
	private let logger: SDKLogger

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameter logger: The logger.
	init(logger: SDKLogger) {
		self.logger = logger
	}
}

// MARK: - BiometricUserVerifier

extension BiometricUserVerifierImpl: BiometricUserVerifier {
	func verifyBiometric(context _: BiometricUserVerificationContext, handler: BiometricUserVerificationHandler) {
		logger.log("Please start biometric user verification.")

		// In case of face recognition authenticator (Face ID) you may show a confirmation screen
		// because the OS provided popup doesn't give the possibility to cancel the process.
		// In the example app automatic verification is selected.
		logger.log("Performing automatic user verification.")
		handler.verify()
	}
}
