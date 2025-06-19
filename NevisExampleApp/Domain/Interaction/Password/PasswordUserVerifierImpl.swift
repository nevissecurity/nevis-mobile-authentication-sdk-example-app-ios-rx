//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2024. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication

/// Default implementation of `PasswordUserVerifier` protocol.
/// For more information about password user verification please read the [official documentation](https://docs.nevis.net/mobilesdk/guide/operation/authentication#password-user-verifier).
///
/// With the help of the ``ResponseEmitter`` it will emit a ``VerifyPasswordResponse``.
class PasswordUserVerifierImpl {

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

// MARK: - PasswordUserVerifier

extension PasswordUserVerifierImpl: PasswordUserVerifier {
	func verifyPassword(context: PasswordUserVerificationContext, handler: PasswordUserVerificationHandler) {
		logger.sdk("Please start Password user verification.")

		let response = VerifyPasswordResponse(protectionStatus: context.authenticatorProtectionStatus,
		                                      handler: handler)
		responseEmitter.subject.onNext(response)
	}
}
