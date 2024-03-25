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

		var accounts = [any Account]()
		supportedAuthenticators.forEach { authenticator in
			authenticator.registration?.registeredAccounts.forEach { account in
				if context.isPolicyCompliant(username: account.username, aaid: authenticator.aaid) {
					if !accounts.contains(where: { $0.username == account.username }) {
						accounts.append(account)
					}
				}
			}
		}

		return accounts
	}
}
