//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2024. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication

/// Default implementation of ``PasswordChanger`` protocol.
///
/// With the help of the ``ResponseEmitter`` it will emit a ``ChangePasswordResponse``.
class PasswordChangerImpl {

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

// MARK: - PasswordChanger

extension PasswordChangerImpl: PasswordChanger {
	func changePassword(context: PasswordChangeContext, handler: PasswordChangeHandler) {
		if context.lastRecoverableError != nil {
			logger.log("Password change failed. Please try again.")
		}
		else {
			logger.log("Please start Password change.")
		}

		let response = ChangePasswordResponse(protectionStatus: context.authenticatorProtectionStatus,
		                                      lastRecoverableError: context.lastRecoverableError,
		                                      handler: handler)
		responseEmitter.subject.onNext(response)
	}

	func passwordPolicy() -> PasswordPolicy {
		policy
	}
}
