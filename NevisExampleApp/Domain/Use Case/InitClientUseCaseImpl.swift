//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication
import RxSwift

/// Default implementation of ``InitClientUseCase`` protocol.
class InitClientUseCaseImpl {

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

// MARK: - InitClientUseCase

extension InitClientUseCaseImpl: InitClientUseCase {
	func execute(configuration: Configuration) -> Observable<()> {
		Observable.create { [weak self] observer in
			if self?.provider.get() != nil {
				logger.sdk("Client already initialized.")
				observer.onNext(())
				observer.onCompleted()
			}
			else {
				logger.sdk("Initializing client.")
				MobileAuthenticationClientInitializer()
					.configuration(configuration)
					.onSuccess { client in
						logger.sdk("Client initialization succeeded.", .green)
						self?.provider.save(client: client)
						observer.onNext(())
						observer.onCompleted()
					}
					.onError {
						logger.sdk("Client initialization failed.", .red)
						observer.onError(OperationError(operation: .initClient,
						                                underlyingError: $0))
					}
					.execute()
			}

			return Disposables.create()
		}
	}
}
