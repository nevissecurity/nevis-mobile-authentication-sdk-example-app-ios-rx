//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2024. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication

/// Default implementation of ``PasswordEnroller`` protocol.
///
/// With the help of the ``ResponseEmitter`` it will emit an ``EnrollPasswordResponse``.
class PasswordEnrollerImpl {

	// MARK: - Properties

	/// The response emitter.
	private let responseEmitter: ResponseEmitter

	/// The logger.
	private let logger: SDKLogger

	/// The password policy.
	private let policy: PasswordPolicy

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameters:
	///   - responseEmitter: The response emitter.
	///   - logger: The logger.
	///   - policy: The password policy.
	init(responseEmitter: ResponseEmitter,
	     logger: SDKLogger,
	     policy: PasswordPolicy) {
		self.responseEmitter = responseEmitter
		self.logger = logger
		self.policy = policy
	}
}

// MARK: - PasswordEnroller

extension PasswordEnrollerImpl: PasswordEnroller {
	func enrollPassword(context: PasswordEnrollmentContext, handler: PasswordEnrollmentHandler) {
		if context.lastRecoverableError != nil {
			logger.log("Password enrollment failed. Please try again.")
		}
		else {
			logger.log("Please start Password enrollment.")
		}

		let response = EnrollPasswordResponse(lastRecoverableError: context.lastRecoverableError,
		                                      handler: handler)
		responseEmitter.subject.onNext(response)
	}

	func passwordPolicy() -> PasswordPolicy {
		policy
	}
}
