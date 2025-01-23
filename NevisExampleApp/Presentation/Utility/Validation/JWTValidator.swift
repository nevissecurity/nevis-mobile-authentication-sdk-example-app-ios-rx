//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import Foundation

/// Class for validating JWT.
final class JWTValidator {

	// MARK: - Properties

	/// The validation message.
	private let message: String

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameter message: The validation message. Default value is "JWT validation failed!".
	init(message: String = "JWT validation failed!") {
		self.message = message
	}
}

// MARK: - Actions

extension JWTValidator {

	/// Validates a JWT.
	///
	/// - Parameter jwt: The JWT to validate.
	/// - Returns: The result of the validation.
	func validate(_ jwt: String) -> ValidationResult {
		let regex = try! NSRegularExpression(pattern: "^[A-Za-z0-9-_=]+\\.[A-Za-z0-9-_=]+\\.?[A-Za-z0-9-_.+/=]*$",
		                                     options: [])
		guard regex.numberOfMatches(in: jwt, range: NSRange(location: 0, length: jwt.count)) > 0 else {
			return .failure(ValidationError(message: message))
		}

		return .success(())
	}
}
