//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication

/// Default implementation of `BiometricUserVerifier` protocol.
/// For more information about biometric user verification please read the [official documentation](https://docs.nevis.net/mobilesdk/guide/operation/registration#biometric-user-verifier).
///
/// With the help of the ``ResponseEmitter`` it will emit a ``VerifyBiometricResponse``.
class BiometricUserVerifierImpl {

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

// MARK: - BiometricUserVerifier

extension BiometricUserVerifierImpl: BiometricUserVerifier {
	func verifyBiometric(context: BiometricUserVerificationContext, handler: BiometricUserVerificationHandler) {
		logger.sdk("Please start biometric user verification.")

		let response = VerifyBiometricResponse(authenticator: context.authenticator.localizedTitle,
		                                       handler: handler)
		responseEmitter.subject.onNext(response)
	}
}
