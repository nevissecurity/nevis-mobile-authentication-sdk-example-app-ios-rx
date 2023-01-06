//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication

/// Protocol declaration for account validation.
protocol AccountValidator {

	/// Validates accounts using a context.
	///
	/// - Parameter context: The context holding the accounts to validate.
	/// - Throws: ``BusinessError`` if supported authenticators are not found.
	/// - Returns: The list of valid accounts.
	func validate(context: AccountSelectionContext) throws -> [any Account]
}
