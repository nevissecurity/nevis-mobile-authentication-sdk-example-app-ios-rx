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

		// The underlying error is either an `AppError` or a `MobileAuthenticationClientError`.
		// As this is an example app, we are directly showing the technical error occurring. Be aware that this is not
		// to be considered best practice. Your own production app should handle the errors in a more appropriate manner
		// such as providing translations for all your supported languages as well as simplifying the error message
		// presented to the end-user in a way non-technical adverse people can understand and act upon them.
		coordinator.navigateToResult(with: .failure(operation: operationError.operation,
		                                            description: operationError.underlyingError.localizedDescription))
		chain.handle(error: error)
	}
}
