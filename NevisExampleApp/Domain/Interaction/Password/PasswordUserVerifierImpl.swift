//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2024. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication

/// Default implementation of ``PasswordUserVerifier`` protocol.
///
/// With the help of the ``ResponseEmitter`` it will emit a ``VerifyPasswordResponse``.
class PasswordUserVerifierImpl {

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

// MARK: - PasswordUserVerifier

extension PasswordUserVerifierImpl: PasswordUserVerifier {
	func verifyPassword(context: PasswordUserVerificationContext, handler: PasswordUserVerificationHandler) {
		if context.lastRecoverableError != nil {
			logger.log("Password user verification failed. Please try again.")
		}
		else {
			logger.log("Please start Password user verification.")
		}

		let response = VerifyPasswordResponse(protectionStatus: context.authenticatorProtectionStatus,
		                                      lastRecoverableError: context.lastRecoverableError,
		                                      handler: handler)
		responseEmitter.subject.onNext(response)
	}
}
