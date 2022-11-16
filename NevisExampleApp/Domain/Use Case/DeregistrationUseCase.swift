//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication
import RxSwift

/// Use case for deregistering the users.
protocol DeregistrationUseCase {

	/// Deregisters the users.
	///
	/// - Parameters:
	///   - username: The username that need to be deregistered. If not provided all user will be deregistered.
	///   - authorizationProvider: Object providing credentials to perform deregistration.
	/// - Returns: The observable sequence that will emit an ``OperationResponse`` object.
	func execute(username: String?, authorizationProvider: AuthorizationProvider?) -> Observable<OperationResponse>
}
