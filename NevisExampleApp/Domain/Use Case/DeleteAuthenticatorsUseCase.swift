//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2023. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication
import RxSwift

/// Use case for deleting local authenticators.
protocol DeleteAuthenticatorsUseCase {

	/// Deletes local authenticators.
	///
	/// - Parameter accounts: The list of enrolled accounts.
	/// - Returns: The observable sequence that will emit an ``OperationResponse`` object.
	func execute(accounts: [any Account]) -> Observable<OperationResponse>
}
