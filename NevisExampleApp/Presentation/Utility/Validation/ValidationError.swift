//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import Foundation

/// Describes a validation related error.
struct ValidationError {

	// MARK: - Properties

	/// The messages of the error.
	let messages: [String]

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameter messages: The list of validation messages.
	init(messages: [String]) {
		self.messages = messages
	}

	/// Creates a new instance.
	///
	/// - Parameter message: The validation message.
	init(message: String) {
		self.init(messages: [message])
	}
}

// MARK: - LocalizedError

extension ValidationError: LocalizedError {

	/// Returns the error description.
	var errorDescription: String? {
		description
	}

	/// Returns the reason of failure.
	var failureReason: String? {
		description
	}
}

// MARK: - CustomStringConvertible

extension ValidationError: CustomStringConvertible {

	/// Returns the error description.
	var description: String {
		messages.joined(separator: "\n")
	}
}

// MARK: - ExpressibleByStringLiteral

extension ValidationError: ExpressibleByStringLiteral {

	/// Creates a new instance from a string.
	///
	/// - Parameter value: The validation message.
	init(stringLiteral value: String) {
		self.init(message: value)
	}
}
