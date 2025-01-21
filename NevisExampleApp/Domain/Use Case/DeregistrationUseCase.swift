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
	///   - usernames: The list of username that need to be deregistered.
	///   - authorizationProvider: Object providing credentials to perform deregistration.
	/// - Returns: The observable sequence that will emit an ``OperationResponse`` object.
	func execute(usernames: [String], authorizationProvider: AuthorizationProvider?) -> Observable<OperationResponse>
}
