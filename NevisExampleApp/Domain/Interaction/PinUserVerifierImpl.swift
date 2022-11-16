//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication

/// Default implementation of ``PinUserVerifier`` protocol.
///
/// With the help of the ``ResponseEmitter`` it will emit a ``VerifyPinResponse``.
class PinUserVerifierImpl {

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

// MARK: - PinUserVerifier

extension PinUserVerifierImpl: PinUserVerifier {
	func verifyPin(context: PinUserVerificationContext, handler: PinUserVerificationHandler) {
		if context.lastRecoverableError != nil {
			logger.log("PIN user verification failed. Please try again.")
		}
		else {
			logger.log("Please start PIN user verification.")
		}

		let response = VerifyPinResponse(protectionStatus: context.authenticatorProtectionStatus,
		                                 lastRecoverableError: context.lastRecoverableError,
		                                 handler: handler)
		responseEmitter.subject.onNext(response)
	}
}
