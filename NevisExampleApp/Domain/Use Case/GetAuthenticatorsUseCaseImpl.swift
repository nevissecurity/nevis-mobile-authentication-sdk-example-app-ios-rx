//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication
import RxSwift

/// Default implementation of ``GetAuthenticatorsUseCase`` protocol.
class GetAuthenticatorsUseCaseImpl {

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

// MARK: - GetAuthenticatorsUseCase

extension GetAuthenticatorsUseCaseImpl: GetAuthenticatorsUseCase {
	func execute() -> Observable<[any Authenticator]> {
		.just(clientProvider.get()?.localData.authenticators ?? [any Authenticator]())
	}
}
