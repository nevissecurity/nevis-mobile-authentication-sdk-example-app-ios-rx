//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import Foundation

/// Default implementation of ``ErrorHandlerChain`` protocol.
final class ErrorHandlerChainImpl {

	// MARK: - Properties

	/// List of ``ErrorHandler`` implementations.
	private var errorHandlers: [ErrorHandler]

	/// The index of the current handler.
	fileprivate var index: Int = -1

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameter errorHandlers: List of ``ErrorHandler`` implementations.
	init(errorHandlers: [ErrorHandler]) {
		self.errorHandlers = errorHandlers
	}
}

// MARK: - ErrorHandlerChain

extension ErrorHandlerChainImpl: ErrorHandlerChain {

	func handle(error: Error) {
		if errorHandlers.isEmpty {
			return
		}

		index += 1
		if index < errorHandlers.count {
			// executing next element in the chain
			errorHandlers[index].handle(error: error, chain: self)
		}
		else {
			// reset the index
			index = -1

			// when an element in the chain is the last, it will return its data.
			return
		}
	}
}
