//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import Foundation

/// Type of validation result.
typealias ValidationResult = Result<(), ValidationError>

extension Result where Failure == ValidationError {

	/// The message of the validation result if any.
	var message: String {
		switch self {
		case .success:
			""
		case let .failure(error):
			error.description
		}
	}

	/// Tells whether the result is valid.
	var isValid: Bool {
		switch self {
		case .success:
			true
		case .failure:
			false
		}
	}
}
