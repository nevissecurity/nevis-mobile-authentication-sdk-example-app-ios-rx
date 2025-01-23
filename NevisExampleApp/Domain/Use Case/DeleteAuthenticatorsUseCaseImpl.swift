//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication
import RxSwift

/// Default implementation of ``DeleteAuthenticatorsUseCase`` protocol.
class DeleteAuthenticatorsUseCaseImpl {

	// MARK: - Properties

	/// The client provider.
	private let provider: ClientProvider

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameters:
	///   - provider: The client provider.
	init(provider: ClientProvider) {
		self.provider = provider
	}
}

// MARK: - DeleteAuthenticatorsUseCase

extension DeleteAuthenticatorsUseCaseImpl: DeleteAuthenticatorsUseCase {
	func execute(accounts: [any Account]) -> Observable<OperationResponse> {
		guard !accounts.isEmpty else {
			logger.sdk("Accounts not found.", .red)
			return .error(BusinessError.accountsNotFound)
		}

		var responses: [Observable<OperationResponse>] = []
		accounts.forEach { account in
			responses.append(deleteAuthenticators(of: account.username))
		}

		return Observable.create { observer in
			Observable.concat(responses)
				.observe(on: MainScheduler.instance)
				.subscribe(on: SerialDispatchQueueScheduler(qos: .background))
				.subscribe(onError: {
				           	logger.sdk("Delete authenticators failed.", .red)
				           	observer.onError(OperationError(operation: .localData,
				           	                                underlyingError: $0))
				           },
				           onCompleted: {
				           	logger.sdk("Delete authenticators succeeded.", .green)
				           	observer.onNext(CompletedResponse(operation: .localData))
				           	observer.onCompleted()
				           })
		}
	}
}

private extension DeleteAuthenticatorsUseCaseImpl {
	/// Deletes all local authenticators of an account.
	///
	/// - Parameter username: The username of the enrolled account.
	func deleteAuthenticators(of username: Username) -> Observable<OperationResponse> {
		Observable.create { [unowned self] observer in
			do {
				try provider.get()?.localData.deleteAuthenticator(username: username, aaid: nil)
				logger.sdk("Delete authenticators succeeded for user %@.", .green, .debug, username)
				observer.onNext(CompletedResponse(operation: .localData))
				observer.onCompleted()
			}
			catch {
				observer.onError(error)
			}

			return Disposables.create()
		}
	}
}
