//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication

/// Default implementation of ``BiometricUserVerifier`` protocol.
///
/// With the help of the ``ResponseEmitter`` it will emit a ``VerifyBiometricResponse``.
class BiometricUserVerifierImpl {

	// MARK: - Properties

	/// The response emitter.
	private let responseEmitter: ResponseEmitter

	/// The logger.
	private let logger: SDKLogger

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameters:
	///   - responseEmitter: The response emitter.
	///   - logger: The logger.
	init(responseEmitter: ResponseEmitter,
	     logger: SDKLogger) {
		self.responseEmitter = responseEmitter
		self.logger = logger
	}
}

// MARK: - BiometricUserVerifier

extension BiometricUserVerifierImpl: BiometricUserVerifier {
	func verifyBiometric(context: BiometricUserVerificationContext, handler: BiometricUserVerificationHandler) {
		logger.log("Please start biometric user verification.")

		let response = VerifyBiometricResponse(authenticator: context.authenticator.localizedTitle,
		                                       handler: handler)
		responseEmitter.subject.onNext(response)
	}
}
