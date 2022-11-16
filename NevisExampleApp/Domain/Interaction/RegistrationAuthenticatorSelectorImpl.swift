//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication

/// The unique name of authenticator selector implementation for Registration operation.
let RegistrationAuthenticatorSelectorName = "auth_selector_reg"

/// Default implementation of ``AuthenticatorSelector`` protocol used for registration.
///
/// With the help of the ``ResponseEmitter`` it will emit a ``SelectAuthenticatorResponse``.
class RegistrationAuthenticatorSelectorImpl {

	// MARK: - Properties

	/// The response emitter.
	private let responseEmitter: ResponseEmitter

	/// The logger.
	private let logger: SDKLogger

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameters:
	///   - responseEmitter: The response emitter.
	///   - logger: The logger.
	init(responseEmitter: ResponseEmitter,
	     logger: SDKLogger) {
		self.responseEmitter = responseEmitter
		self.logger = logger
	}
}

// MARK: - AuthenticatorSelector

extension RegistrationAuthenticatorSelectorImpl: AuthenticatorSelector {
	func selectAuthenticator(context: AuthenticatorSelectionContext, handler: AuthenticatorSelectionHandler) {
		logger.log("Please select one of the received available authenticators!")
		let authenticators = context.authenticators.filter {
			$0.isSupportedByHardware && context.isPolicyCompliant(authenticatorAaid: $0.aaid)
		}

		let response = SelectAuthenticatorResponse(authenticators: authenticators,
		                                           handler: handler)
		responseEmitter.subject.onNext(response)
	}
}
