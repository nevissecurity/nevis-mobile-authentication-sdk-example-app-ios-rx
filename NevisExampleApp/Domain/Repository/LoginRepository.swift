//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import RxSwift

/// Repository for Login operation.
protocol LoginRepository {

	/// Logs in a user with the given `username` and `password`.
	///
	/// - Parameters:
	///   - url: The url of the login endpoint.
	///   - username: The username.
	///   - password: The password.
	/// - Returns: The observable sequence that will emit a ``Credentials`` object.
	func execute(url: URL, username: String, password: String) -> Observable<Credentials>
}
