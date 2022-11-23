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

	/// Returns a string escaped for `application/x-www-form-urlencoded` encoding.
	///
	/// - Returns: The encoded string.
	func escape() -> String {
		var characterSet = CharacterSet.urlQueryAllowed
		characterSet.insert(charactersIn: " ")
		characterSet.remove(charactersIn: "+/?")

		return addingPercentEncoding(withAllowedCharacters: characterSet)!
			.replacingOccurrences(of: " ", with: "+")
	}
}

extension String? {

	/// Tells whether a string is empty or nil.
	var isEmptyOrNil: Bool {
		self?.isEmpty ?? true
	}
}
