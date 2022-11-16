//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import Foundation

extension String {

	/// Tells whether a string contains only numeric characters.
	var isNumeric: Bool {
		!isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
	}

	/// Checks whether a string contains only alpha numeric characters.
	///
	/// - Parameter ignoreDiacritics: Flag that tells whether diacritics should be ignored. Default value is `false`.
	func isAlphanumeric(ignoreDiacritics: Bool = false) -> Bool {
		!isEmpty && ignoreDiacritics ?
			range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil :
			rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) == nil
	}

	/// Percent escapes the instance.
	func percentEscaped() -> String {
		var characterSet = CharacterSet.alphanumerics
		characterSet.insert(charactersIn: "-._* ")

		return addingPercentEncoding(withAllowedCharacters: characterSet)!
			.replacingOccurrences(of: " ", with: "+")
	}
}

extension Optional where Wrapped == String {

	/// Tells whether a string is empty or nil.
	var isEmptyOrNil: Bool {
		return self?.isEmpty ?? true
	}
}
