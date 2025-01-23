//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2024 Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication

/// Password policy related errors.
enum PasswordPolicyError: Error {
	/// Invalid password.
	case invalidPassword
}

extension PasswordPolicyError: LocalizedError {
	/// A message describing what error occurred.
	public var errorDescription: String? {
		switch self {
		case .invalidPassword:
			L10n.Credential.Password.Policy.errorCause
		}
	}
}

/// Implementation of the `PasswordPolicy`.
/// This policy validates the password entered by the user during registration or password changing,
/// and allows only passwords that are not equal to `password`.
final class PasswordPolicyImpl {}

// MARK: PasswordPolicy

extension PasswordPolicyImpl: PasswordPolicy {
	func validatePasswordForEnrollment(_ password: String, onSuccess: @escaping () -> (), onError: @escaping (PasswordEnrollmentValidationError) -> ()) {
		guard isValid(password) else {
			return onError(.InvalidPassword(message: errorMessage, cause: PasswordPolicyError.invalidPassword))
		}
		onSuccess()
	}

	func validatePasswordForPasswordChange(_ password: String, onSuccess: @escaping () -> (), onError: @escaping (PasswordChangeValidationError) -> ()) {
		guard isValid(password) else {
			return onError(.InvalidPassword(message: errorMessage, cause: PasswordPolicyError.invalidPassword))
		}
		onSuccess()
	}
}

// MARK: - Private extension

private extension PasswordPolicyImpl {
	/// The validation error message.
	var errorMessage: String {
		L10n.Credential.Password.Policy.errorMessage
	}

	/// Returns a Boolean value indicating whether a password is valid.
	///
	/// - Parameter password: The password to validate.
	/// - Returns: A Boolean value indicating whether a password is valid.
	func isValid(_ password: String) -> Bool {
		password.trimmingCharacters(in: .whitespacesAndNewlines) != "password"
	}
}
