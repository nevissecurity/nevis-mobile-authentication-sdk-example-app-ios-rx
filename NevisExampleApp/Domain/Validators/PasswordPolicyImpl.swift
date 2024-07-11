//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2024 Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication

/// Implementation of the ``PasswordPolicy``.
/// This policy validates the password entered by the user during registration or password changing,
/// and allows only passwords longer than 6 characters.
final class PasswordPolicyImpl {}

// MARK: PasswordPolicy

extension PasswordPolicyImpl: PasswordPolicy {
	func validatePasswordForEnrollment(_ password: String, onSuccess: @escaping () -> (), onError: @escaping (PasswordEnrollmentValidationError) -> ()) {
		guard isValid(password) else {
			return onError(.InvalidPassword(message: errorMessage))
		}
		onSuccess()
	}

	func validatePasswordForPasswordChange(_ password: String, onSuccess: @escaping () -> (), onError: @escaping (PasswordChangeValidationError) -> ()) {
		guard isValid(password) else {
			return onError(.InvalidPassword(message: errorMessage))
		}
		onSuccess()
	}
}

// MARK: - Private extension

private extension PasswordPolicyImpl {
	var errorMessage: String {
		"The password must be more than 6 characters."
	}

	func isValid(_ password: String) -> Bool {
		password.trimmingCharacters(in: .whitespacesAndNewlines).count >= 6
	}
}
