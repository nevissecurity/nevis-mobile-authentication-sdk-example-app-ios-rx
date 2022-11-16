//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication
import RxSwift

/// Use case for login a user.
protocol LoginUseCase {

	/// Logs in a user.
	///
	/// - Parameters:
	///   - url: The url of the login endpoint.
	///   - username: The username.
	///   - password: The password.
	/// - Returns: The observable sequence that will emit a ``Credentials`` object.
	func execute(url: URL, username: String, password: String) -> Observable<Credentials>
}
