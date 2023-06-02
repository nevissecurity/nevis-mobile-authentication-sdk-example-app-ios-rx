//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication

/// The unique name of authenticator selector implementation for Authentication operation.
let AuthenticationAuthenticatorSelectorName = "auth_selector_auth"

/// Default implementation of ``AuthenticatorSelector`` protocol used for authentication.
///
/// With the help of the ``ResponseEmitter`` it will emit a ``SelectAuthenticatorResponse``.
class AuthenticationAuthenticatorSelectorImpl {

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

extension AuthenticationAuthenticatorSelectorImpl: AuthenticatorSelector {
	func selectAuthenticator(context: AuthenticatorSelectionContext, handler: AuthenticatorSelectionHandler) {
		logger.log("Please select one of the received available authenticators!")
		let authenticatorItems = context.authenticators.filter {
			guard let registration = $0.registration else {
				return false
			}

			// Do not display:
			//   - policy non-registered authenticators
			//   - not hardware supported authenticators.
			return $0.isSupportedByHardware && registration.isRegistered(context.account.username)
		}.map {
			AuthenticatorItem(authenticator: $0,
			                  isPolicyCompliant: context.isPolicyCompliant(authenticatorAaid: $0.aaid),
			                  isUserEnrolled: $0.isEnrolled(username: context.account.username))
		}

		let response = SelectAuthenticatorResponse(authenticatorItems: authenticatorItems,
		                                           handler: handler)
		responseEmitter.subject.onNext(response)
	}
}
