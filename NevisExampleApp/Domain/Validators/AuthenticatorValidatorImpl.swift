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
			let allowedAuthenticators = self.allowedAuthenticators(context: context, allowlistedAuthenticators: configuration.authenticatorAllowlist).filter { authenticator in
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
			let allowedAuthenticators = self.allowedAuthenticators(context: context, allowlistedAuthenticators: configuration.authenticatorAllowlist).filter { authenticator in
				// Do not display:
				//   - policy non-registered authenticators,
				//   - not hardware supported authenticators.
				authenticator.isSupportedByHardware && authenticator.registration.isRegistered(context.account.username)
			}

			if allowedAuthenticators.isEmpty {
				return .error(BusinessError.authenticatorNotFound)
			}

			return .just(allowedAuthenticators)
		}
	}
}

// MARK: Filtering based on the authenticator allowlist

private extension AuthenticatorValidatorImpl {
	/// Filters out non-allowlisted authenticators.
	///
	/// - Parameter context: The context holding the accounts to validate.
	/// - Parameter allowlistedAuthenticators: The array holding the allowlisted authenticators.
	/// - Returns: The list of allowed authenticators.
	func allowedAuthenticators(context: AuthenticatorSelectionContext, allowlistedAuthenticators: [AuthenticatorAaid]) -> [any Authenticator] {
		context.authenticators.filter { authenticator in
			guard let authenticatorAaid = AuthenticatorAaid(rawValue: authenticator.aaid) else { return false }
			return allowlistedAuthenticators.contains(authenticatorAaid)
		}
	}
}
