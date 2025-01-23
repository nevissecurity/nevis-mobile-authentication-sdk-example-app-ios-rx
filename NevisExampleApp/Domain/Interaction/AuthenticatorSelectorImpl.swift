//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication
import RxSwift

/// The unique name of authenticator selector implementation for Registration operation.
let RegistrationAuthenticatorSelectorName = "auth_selector_reg"

/// The unique name of authenticator selector implementation for Authentication operation.
let AuthenticationAuthenticatorSelectorName = "auth_selector_auth"

/// Default implementation of `AuthenticatorSelector` protocol.
/// For more information about authenticator selection please read the [official documentation](https://docs.nevis.net/mobilesdk/guide/operation/registration#authenticator-selector).
///
/// With the help of the ``ResponseEmitter`` it will emit a ``SelectAuthenticatorResponse``.
class AuthenticatorSelectorImpl {

	/// Supported operations for authenticator selection.
	enum Operation {
		/// Registration operation.
		case registration
		/// Authentication operation.
		case authentication
	}

	// MARK: - Properties

	/// The authenticator validator.
	private let authenticatorValidator: AuthenticatorValidator

	/// The current operation.
	private let operation: Operation

	/// The response emitter.
	private let responseEmitter: ResponseEmitter

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameters:
	///   - authenticatorValidator: The authenticator validator.
	///   - operation: The current operation.
	///   - responseEmitter: The response emitter.
	init(authenticatorValidator: AuthenticatorValidator,
	     operation: Operation,
	     responseEmitter: ResponseEmitter) {
		self.authenticatorValidator = authenticatorValidator
		self.operation = operation
		self.responseEmitter = responseEmitter
	}
}

// MARK: - AuthenticatorSelector

extension AuthenticatorSelectorImpl: AuthenticatorSelector {
	func selectAuthenticator(context: AuthenticatorSelectionContext, handler: AuthenticatorSelectionHandler) {
		logger.sdk("Please select one of the received available authenticators!")

		let validationResult = switch operation {
		case .registration: authenticatorValidator.validateForRegistration(context: context)
		case .authentication: authenticatorValidator.validateForAuthentication(context: context)
		}

		validationResult.subscribe(
			onNext: { authenticators in
				let autheticators = authenticators.map { authenticator in
					AuthenticatorItem(authenticator: authenticator,
					                  isPolicyCompliant: context.isPolicyCompliant(authenticatorAaid: authenticator.aaid),
					                  isUserEnrolled: authenticator.isEnrolled(username: context.account.username))
				}

				let response = SelectAuthenticatorResponse(authenticatorItems: autheticators,
				                                           handler: handler)
				self.responseEmitter.subject.onNext(response)
			},
			onError: { error in
				logger.sdk("Authenticator selection failed due to %@", .red, .debug, error.localizedDescription)
				handler.cancel()
			}
		).dispose()
	}
}
