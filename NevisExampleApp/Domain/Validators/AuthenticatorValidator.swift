//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2024 Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication
import RxSwift

/// Protocol declaration for authenticator validation.
protocol AuthenticatorValidator {

	/// Validates authenticators for registration.
	///
	/// - Parameter context: The context holding the accounts to validate.
	/// - Throws: ``BusinessError`` if supported authenticators are not found.
	/// - Returns: The observable sequence that will emit an `Authenticator` array.
	func validateForRegistration(context: AuthenticatorSelectionContext) -> Observable<[any Authenticator]>

	/// Validates authenticators for authentication.
	///
	/// - Parameter context: The context holding the accounts to validate.
	/// - Throws: ``BusinessError`` if supported authenticators are not found.
	/// - Returns: The observable sequence that will emit an `Authenticator` array.
	func validateForAuthentication(context: AuthenticatorSelectionContext) -> Observable<[any Authenticator]>
}
