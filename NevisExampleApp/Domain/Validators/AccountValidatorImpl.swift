//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication

/// Default implementation of ``AccountValidator`` protocol.
class AccountValidatorImpl {}

// MARK: - AccountValidator

extension AccountValidatorImpl: AccountValidator {
	func validate(context: AccountSelectionContext) throws -> [any Account] {
		let supportedAuthenticators = context.authenticators.filter(\.isSupportedByHardware)
		if supportedAuthenticators.isEmpty {
			throw BusinessError.authenticatorNotFound
		}

		var accounts: [Username: any Account] = [:]
		supportedAuthenticators.forEach { authenticator in
			authenticator.registration.registeredAccounts.forEach { account in
				if context.isPolicyCompliant(username: account.username, aaid: authenticator.aaid) {
					accounts[account.username] = account
				}
			}
		}

		return accounts.values.map { $0 }
	}
}
