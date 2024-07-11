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

/// Default implementation of ``AuthenticatorSelector`` protocol.
///
/// With the help of the ``ResponseEmitter`` it will emit a ``SelectAuthenticatorResponse``.
class AuthenticatorSelectorImpl {

	enum Operation {
		case registration
		case authentication
	}

	// MARK: - Properties

	/// The authenticator validator.
	private let authenticatorValidator: AuthenticatorValidator

	/// The current operation.
	private let operation: Operation

	/// The response emitter.
	private let responseEmitter: ResponseEmitter

	/// The logger.
	private let logger: SDKLogger

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameters:
	///   - authenticatorValidator: The authenticator validator.
	///   - operation: The current operation.
	///   - responseEmitter: The response emitter.
	///   - logger: The logger.
	init(authenticatorValidator: AuthenticatorValidator,
	     operation: Operation,
	     responseEmitter: ResponseEmitter,
	     logger: SDKLogger) {
		self.authenticatorValidator = authenticatorValidator
		self.operation = operation
		self.responseEmitter = responseEmitter
		self.logger = logger
	}
}

// MARK: - AuthenticatorSelector

extension AuthenticatorSelectorImpl: AuthenticatorSelector {
	func selectAuthenticator(context: AuthenticatorSelectionContext, handler: AuthenticatorSelectionHandler) {
		logger.log("Please select one of the received available authenticators!")

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
				self.logger.log("Authenticator selection failed due to \(error.localizedDescription)", color: .red)
				handler.cancel()
			}
		).dispose()
	}
}
