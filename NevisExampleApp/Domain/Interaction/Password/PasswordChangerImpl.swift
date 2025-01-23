//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2024. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication

/// Default implementation of `PasswordChanger` protocol.
/// For more information about password change please read the [official documentation](https://docs.nevis.net/mobilesdk/guide/operation/other-operations#change-password).
///
/// With the help of the ``ResponseEmitter`` it will emit a ``ChangePasswordResponse``.
class PasswordChangerImpl {

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

// MARK: - PasswordChanger

extension PasswordChangerImpl: PasswordChanger {
	func changePassword(context: PasswordChangeContext, handler: PasswordChangeHandler) {
		if context.lastRecoverableError != nil {
			logger.sdk("Password change failed. Please try again.", .red)
		}
		else {
			logger.sdk("Please start Password change.")
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
