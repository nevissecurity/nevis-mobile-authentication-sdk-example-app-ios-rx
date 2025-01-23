//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication

/// Default implementation of `PinUserVerifier` protocol.
/// For more information about PIN user verification please read the [official documentation](https://docs.nevis.net/mobilesdk/guide/operation/authentication#pin-user-verifier).
///
/// With the help of the ``ResponseEmitter`` it will emit a ``VerifyPinResponse``.
class PinUserVerifierImpl {

	// MARK: - Properties

	/// The response emitter.
	private let responseEmitter: ResponseEmitter

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameters:
	///   - responseEmitter: The response emitter.
	init(responseEmitter: ResponseEmitter) {
		self.responseEmitter = responseEmitter
	}
}

// MARK: - PinUserVerifier

extension PinUserVerifierImpl: PinUserVerifier {
	func verifyPin(context: PinUserVerificationContext, handler: PinUserVerificationHandler) {
		if context.lastRecoverableError != nil {
			logger.sdk("PIN user verification failed. Please try again.", .red)
		}
		else {
			logger.sdk("Please start PIN user verification.")
		}

		let response = VerifyPinResponse(protectionStatus: context.authenticatorProtectionStatus,
		                                 lastRecoverableError: context.lastRecoverableError,
		                                 handler: handler)
		responseEmitter.subject.onNext(response)
	}
}
