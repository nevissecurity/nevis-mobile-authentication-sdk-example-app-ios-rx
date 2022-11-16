//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import RxSwift

/// Default implementation of ``LoginRepository`` protocol.
class LoginRepositoryImpl {

	// MARK: - Properties

	/// The data source.
	private let dataSoruce: LoginDataSource

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameter dataSoruce: The data source.
	init(dataSoruce: LoginDataSource) {
		self.dataSoruce = dataSoruce
	}
}

// MARK: - LoginRepository

extension LoginRepositoryImpl: LoginRepository {
	func execute(url: URL, username: String, password: String) -> Observable<Credentials> {
		Observable.just(LoginRequest(url: url,
		                             username: username,
		                             password: password))
			.flatMap { self.dataSoruce.execute(request: $0) }
			.map { Credentials(username: $0.extId, cookies: $0.cookies) }
	}
}
