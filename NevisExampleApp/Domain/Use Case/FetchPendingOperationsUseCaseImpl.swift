//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication
import RxSwift

/// Default implementation of ``FetchPendingOperationsUseCase`` protocol.
class FetchPendingOperationsUseCaseImpl {

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

// MARK: - FetchPendingOperationsUseCase

extension FetchPendingOperationsUseCaseImpl: FetchPendingOperationsUseCase {
	func execute() -> Observable<PendingOutOfBandOperationsResult> {
		Observable.create { [weak self] observer in
			logger.sdk("Fetching pending out-of-band operations.", .black, .debug)
			let client = self?.clientProvider.get()
			client?.operations.pendingOutOfBandOperations
				.onResult { result in
					guard result.errors.isEmpty else {
						let errors = result.errors.map(\.localizedDescription).joined(separator: ", ")
						logger.sdk("Fetching pending out-of-band operations failed. Error(s): %@", .red, .error, errors)
						return observer.onError(OperationError(operation: .fetchPendingOperations,
						                                       underlyingError: result.errors.first!))
					}

					logger.sdk("Fetching pending out-of-band operations succeeded.", .green, .debug)
					observer.onNext(result)
					observer.onCompleted()
				}
				.execute()

			return Disposables.create()
		}
	}
}
