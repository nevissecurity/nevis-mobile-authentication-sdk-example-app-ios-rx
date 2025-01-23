//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication
import RxSwift

/// Default implementation of ``DeregistrationUseCase`` protocol.
class DeregistrationUseCaseImpl {

	// MARK: - Properties

	/// The client provider.
	private let clientProvider: ClientProvider

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameters:
	///   - clientProvider: The client provider.
	init(clientProvider: ClientProvider) {
		self.clientProvider = clientProvider
	}
}

// MARK: - DeregistrationUseCase

extension DeregistrationUseCaseImpl: DeregistrationUseCase {
	func execute(usernames: [String], authorizationProvider: AuthorizationProvider?) -> Observable<OperationResponse> {
		let responses = usernames.map { deregister(username: $0, authorizationProvider: authorizationProvider) }

		return Observable.create { observer in
			Observable.concat(responses)
				.observe(on: MainScheduler.instance)
				.subscribe(on: SerialDispatchQueueScheduler(qos: .background))
				.subscribe(onError: {
				           	logger.sdk("Deregistration failed.", .red)
				           	observer.onError(OperationError(operation: .deregistration,
				           	                                underlyingError: $0))
				           },
				           onCompleted: {
				           	observer.onNext(CompletedResponse(operation: .deregistration))
				           	observer.onCompleted()
				           })
		}
	}
}

private extension DeregistrationUseCaseImpl {

	/// Deregisters an authenticator for the given user.
	///
	/// - Parameters:
	///  - username: The username that must be deregistered.
	///  - authorizationProvider: The authorization provider that must be used to deregister the authenticator.
	/// - Returns: The observable sequence that will emit an ``OperationResponse`` object.
	func deregister(username: String, authorizationProvider: AuthorizationProvider?) -> Observable<OperationResponse> {
		Observable.create { [weak self] observer in
			logger.sdk("Deregistering authenticator for user %@", .black, .debug, username)
			let client = self?.clientProvider.get()
			let operation = client?.operations.deregistration
				.username(username)
				.onSuccess {
					logger.sdk("Deregistration succeeded for authenticator for user %@", .green, .debug, username)
					observer.onNext(CompletedResponse(operation: .deregistration))
					observer.onCompleted()
				}
				.onError(observer.onError)

			if let authorizationProvider {
				operation?.authorizationProvider(authorizationProvider)
			}

			operation?.execute()
			return Disposables.create()
		}
	}
}
