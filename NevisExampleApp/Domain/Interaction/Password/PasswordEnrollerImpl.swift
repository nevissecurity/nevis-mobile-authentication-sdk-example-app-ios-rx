//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2024. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication

/// Default implementation of `PasswordEnroller` protocol.
/// For more information about password enrollment please read the [official documentation](https://docs.nevis.net/mobilesdk/guide/operation/registration#password-enroller).
///
/// With the help of the ``ResponseEmitter`` it will emit an ``EnrollPasswordResponse``.
class PasswordEnrollerImpl {

	// MARK: - Properties

	/// The response emitter.
	private let responseEmitter: ResponseEmitter

	/// The password policy.
	private let policy: PasswordPolicy

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameters:
	///   - responseEmitter: The response emitter.
	///   - policy: The password policy.
	init(responseEmitter: ResponseEmitter,
	     policy: PasswordPolicy) {
		self.responseEmitter = responseEmitter
		self.policy = policy
	}
}

// MARK: - PasswordEnroller

extension PasswordEnrollerImpl: PasswordEnroller {
	func enrollPassword(context: PasswordEnrollmentContext, handler: PasswordEnrollmentHandler) {
		if context.lastRecoverableError != nil {
			logger.sdk("Password enrollment failed. Please try again.", .red)
		}
		else {
			logger.sdk("Please start Password enrollment.")
		}

		let response = EnrollPasswordResponse(lastRecoverableError: context.lastRecoverableError,
		                                      handler: handler)
		responseEmitter.subject.onNext(response)
	}

	func passwordPolicy() -> PasswordPolicy {
		policy
	}
}
