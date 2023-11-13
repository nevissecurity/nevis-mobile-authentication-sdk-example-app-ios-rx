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

	/// The logger.
	private let logger: SDKLogger

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameters:
	///   - clientProvider: The client provider.
	///   - logger: The logger.
	init(provider: ClientProvider,
	     logger: SDKLogger) {
		self.provider = provider
		self.logger = logger
	}
}

// MARK: - DeleteAuthenticatorsUseCase

extension DeleteAuthenticatorsUseCaseImpl: DeleteAuthenticatorsUseCase {
	func execute(accounts: [any Account]) -> Observable<OperationResponse> {
		guard !accounts.isEmpty else {
			logger.log("Accounts not found.", color: .red)
			return .error(BusinessError.accountsNotFound)
		}

		var responses: [Observable<OperationResponse>] = []
		accounts.forEach { account in
			responses.append(deleteAuthenticators(of: account.username))
		}

		return Observable.create { [weak self] observer in
			Observable.concat(responses)
				.observe(on: MainScheduler.instance)
				.subscribe(on: SerialDispatchQueueScheduler(qos: .background))
				.subscribe(onError: {
				           	self?.logger.log("Delete authenticators failed.", color: .green)
				           	observer.onError(OperationError(operation: .localData,
				           	                                underlyingError: $0))
				           },
				           onCompleted: {
				           	self?.logger.log("Delete authenticators succeeded.", color: .green)
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
				try self.provider.get()?.localData.deleteAuthenticator(username: username, aaid: nil)
				self.logger.log("Delete authenticators succeeded for user \(username).", color: .green)
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
