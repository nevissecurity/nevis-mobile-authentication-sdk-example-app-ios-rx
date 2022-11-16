//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication
import RxSwift

/// Default implementation of ``LoginUseCase`` protocol.
class LoginUseCaseImpl {

	// MARK: - Properties

	/// The repository.
	private let repository: LoginRepository

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameter repository: The repository.
	init(repository: LoginRepository) {
		self.repository = repository
	}
}

// MARK: - LoginUseCase

extension LoginUseCaseImpl: LoginUseCase {
	func execute(url: URL, username: String, password: String) -> Observable<Credentials> {
		repository.execute(url: url, username: username, password: password)
	}
}
