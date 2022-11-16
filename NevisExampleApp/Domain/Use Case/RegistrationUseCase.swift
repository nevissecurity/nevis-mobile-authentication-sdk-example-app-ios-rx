//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication
import RxSwift

/// Use case for registrering a user with a username.
protocol RegistrationUseCase {

	/// Registers a user with the given `username`.
	///
	/// - Parameters:
	///   - username: The username.
	///   - authorizationProvider: Object providing credentials to perform registration.
	/// - Returns: The observable sequence that will emit an ``OperationResponse`` object.
	func execute(username: String, authorizationProvider: AuthorizationProvider?) -> Observable<OperationResponse>
}
