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

// MARK: - InitClientUseCase

extension InitClientUseCaseImpl: InitClientUseCase {
	func execute(configuration: Configuration) -> Observable<()> {
		Observable.create { [weak self] observer in
			if self?.provider.get() != nil {
				self?.logger.log("Client already initialized.")
				observer.onNext(())
				observer.onCompleted()
			}
			else {
				self?.logger.log("Initializing client.")
				MobileAuthenticationClientInitializer()
					.configuration(configuration)
					.onSuccess { client in
						self?.logger.log("Client initialization succeeded.", color: .green)
						self?.provider.save(client: client)
						observer.onNext(())
						observer.onCompleted()
					}
					.onError {
						self?.logger.log("Client initialization failed.", color: .red)
						observer.onError(OperationError(operation: .initClient,
						                                underlyingError: $0))
					}
					.execute()
			}

			return Disposables.create()
		}
	}
}
