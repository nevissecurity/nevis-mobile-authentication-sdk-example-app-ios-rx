//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication
import RxSwift

/// Use case for retrieving the authenticators.
protocol GetAuthenticatorsUseCase {

	/// Retrieves the authenticators.
	///
	/// - Returns: The observable sequence that will emit a list of ``Authenticator`` objects.
	func execute() -> Observable<[any Authenticator]>
}
