//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication

/// The unique name of Nevis error handler.
let NevisErrorHandlerName = "error_handler_nevis"

/// An ``ErrorHandler`` implementation for Nevis specific error handling.
final class NevisErrorHandler {

	// MARK: - Properties

	/// The application coordinator.
	private let coordinator: AppCoordinator

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameters:
	///  - coordinator: The application coordinator.
	init(coordinator: AppCoordinator) {
		self.coordinator = coordinator
	}
}

// MARK: - ErrorHandler

extension NevisErrorHandler: ErrorHandler {

	func handle(error: Error, chain: ErrorHandlerChain) {
		guard let operationError = error as? OperationError else {
			logger.app("Error is not an Operation error.")
			chain.handle(error: error)
			return
		}

		logger.sdk("Operation error occurred: %@", .red, .debug, operationError.underlyingError.localizedDescription)

		coordinator.navigateToResult(with: .failure(operation: operationError.operation,
		                                            description: operationError.underlyingError.localizedDescription))
		chain.handle(error: error)
	}
}
