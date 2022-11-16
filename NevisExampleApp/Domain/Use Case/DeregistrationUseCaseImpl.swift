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

	/// The logger.
	private let logger: SDKLogger

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameters:
	///   - clientProvider: The client provider.
	///   - logger: The logger.
	init(clientProvider: ClientProvider,
	     logger: SDKLogger) {
		self.clientProvider = clientProvider
		self.logger = logger
	}
}

// MARK: - DeregistrationUseCase

extension DeregistrationUseCaseImpl: DeregistrationUseCase {
	func execute(username: String?, authorizationProvider: AuthorizationProvider?) -> Observable<OperationResponse> {
		guard let authenticators = clientProvider.get()?.localData.authenticators else {
			return .just(CompletedResponse(operation: .deregistration))
		}

		var responses = [Observable<OperationResponse>]()
		authenticators.forEach { authenticator in
			if let username = username {
				// deregister only an account
				if let registration = authenticator.registration, registration.isRegistered(username) {
					responses.append(deregister(username: username,
					                            aaid: authenticator.aaid,
					                            authorizationProvider: authorizationProvider))
				}
			}
			else {
				// username not provided, deregister all account
				authenticator.registration?.registeredAccounts.forEach { account in
					responses.append(deregister(username: account.username,
					                            aaid: authenticator.aaid,
					                            authorizationProvider: authorizationProvider))
				}
			}
		}

		return Observable.create { [weak self] observer in
			Observable.concat(responses)
				.observe(on: MainScheduler.instance)
				.subscribe(on: SerialDispatchQueueScheduler(qos: .background))
				.subscribe(onError: {
				           	self?.logger.log("Deregistration failed.", color: .red)
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
	///  - aaid: The AAID of the ``Authenticator`` that must be deregistered.
	///  - authorizationProvider: The authorization provider that must be used to deregister the authenticator.
	/// - Returns: The observable sequence that will emit an ``OperationResponse`` object.
	func deregister(username: String, aaid: String, authorizationProvider: AuthorizationProvider?) -> Observable<OperationResponse> {
		Observable.create { [weak self] observer in
			self?.logger.log("Deregistering authenticator with aaid \(aaid) for user \(username)")
			let client = self?.clientProvider.get()
			let operation = client?.operations.deregistration
				.username(username)
				.aaid(aaid)
				.onSuccess {
					self?.logger.log("Deregistration succeeded for authenticator with aaid \(aaid) for user \(username)", color: .green)
					observer.onNext(CompletedResponse(operation: .deregistration))
					observer.onCompleted()
				}
				.onError(observer.onError)

			if let authorizationProvider = authorizationProvider {
				operation?.authorizationProvider(authorizationProvider)
			}

			operation?.execute()
			return Disposables.create()
		}
	}
}
