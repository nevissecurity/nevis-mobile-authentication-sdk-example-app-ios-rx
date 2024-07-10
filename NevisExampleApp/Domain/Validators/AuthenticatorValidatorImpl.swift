//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2024 Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication
import RxSwift

/// Default implementation of ``AuthenticatorValidator`` protocol.
final class AuthenticatorValidatorImpl {
	// MARK: - Properties

	/// The configuration loader.
	private let configurationLoader: ConfigurationLoader

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameters:
	///   - configurationLoader: The configuration loader.
	init(configurationLoader: ConfigurationLoader) {
		self.configurationLoader = configurationLoader
	}
}

// MARK: - AuthenticatorValidator

extension AuthenticatorValidatorImpl: AuthenticatorValidator {
	func validateForRegistration(context: AuthenticatorSelectionContext) -> Observable<[any Authenticator]> {
		configurationLoader.load().flatMap { configuration -> Observable<[any Authenticator]> in
			let allowedAuthenticators = self.allowedAuthenticators(context: context, whitelistedAuthenticators: configuration.authenticatorWhitelist).filter { authenticator in
				// Do not display:
				//   - policy non-compliant authenticators (this includes already registered authenticators)
				//   - not hardware supported authenticators.
				authenticator.isSupportedByHardware && context.isPolicyCompliant(authenticatorAaid: authenticator.aaid)
			}

			if allowedAuthenticators.isEmpty {
				return .error(BusinessError.authenticatorNotFound)
			}

			return .just(allowedAuthenticators)
		}
	}

	func validateForAuthentication(context: AuthenticatorSelectionContext) -> Observable<[any Authenticator]> {
		configurationLoader.load().flatMap { configuration -> Observable<[any Authenticator]> in
			let allowedAuthenticators = self.allowedAuthenticators(context: context, whitelistedAuthenticators: configuration.authenticatorWhitelist).filter { authenticator in
				guard let registration = authenticator.registration else { return false }

				// Do not display:
				//   - policy non-registered authenticators,
				//   - not hardware supported authenticators.
				return authenticator.isSupportedByHardware && registration.isRegistered(context.account.username)
			}

			if allowedAuthenticators.isEmpty {
				return .error(BusinessError.authenticatorNotFound)
			}

			return .just(allowedAuthenticators)
		}
	}
}

// MARK: Filtering based on the authenticator whitelist

private extension AuthenticatorValidatorImpl {
	/// Filters out non-whitelisted authenticators.
	///
	/// - Parameter context: The context holding the accounts to validate.
	/// - Parameter whitelistedAuthenticators: The array holding the whitelisted authenticators.
	/// - Returns: The list of allowed authenticators.
	func allowedAuthenticators(context: AuthenticatorSelectionContext, whitelistedAuthenticators: [AuthenticatorAaid]) -> [any Authenticator] {
		context.authenticators.filter { authenticator in
			guard let authenticatorAaid = AuthenticatorAaid(rawValue: authenticator.aaid) else { return false }
			return whitelistedAuthenticators.contains(authenticatorAaid)
		}
	}
}
