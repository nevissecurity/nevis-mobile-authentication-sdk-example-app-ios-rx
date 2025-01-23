//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication
import RxSwift

/// Use case for retrieving the registered accounts.
protocol GetAccountsUseCase {

	/// Retrieves the registered accounts.
	///
	/// - Returns: The observable sequence that will emit a list of `Account` objects.
	func execute() -> Observable<[any Account]>
}
