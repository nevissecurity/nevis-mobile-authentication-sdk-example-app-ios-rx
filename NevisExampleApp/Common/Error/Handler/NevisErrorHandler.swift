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

	/// The logger.
	private let logger: SDKLogger

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameters:
	///  - coordinator: The application coordinator.
	///  - logger: The logger.
	init(coordinator: AppCoordinator,
	     logger: SDKLogger) {
		self.coordinator = coordinator
		self.logger = logger
	}
}

// MARK: - ErrorHandler

extension NevisErrorHandler: ErrorHandler {

	func handle(error: Error, chain: ErrorHandlerChain) {
		guard let operationError = error as? OperationError else {
			os_log("Error is not an Operation error.", log: OSLog.default, type: .debug)
			chain.handle(error: error)
			return
		}

		logger.log("Operation error occurred: \(operationError.underlyingError.localizedDescription)", color: .red)

		coordinator.navigateToResult(with: .failure(operation: operationError.operation,
		                                            description: operationError.underlyingError.localizedDescription))
		chain.handle(error: error)
	}
}
