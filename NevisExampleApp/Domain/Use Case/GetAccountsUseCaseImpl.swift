//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication
import RxSwift

/// Default implementation of ``GetAccountsUseCase`` protocol.
class GetAccountsUseCaseImpl {

	// MARK: - Properties

	/// The client provider.
	private let clientProvider: ClientProvider

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameter clientProvider: The client provider.
	init(clientProvider: ClientProvider) {
		self.clientProvider = clientProvider
	}
}

// MARK: - GetAccountsUseCase

extension GetAccountsUseCaseImpl: GetAccountsUseCase {
	func execute() -> Observable<Set<Account>> {
		.just(clientProvider.get()?.localData.accounts ?? Set<Account>())
	}
}
