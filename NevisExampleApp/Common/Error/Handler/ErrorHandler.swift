//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import Foundation

/// Describes error handling related operations.
protocol ErrorHandler {

	/// Handles the error.
	///
	/// - Parameters:
	///   - error: The error to handle.
	///   - chain: The error handler chain.
	func handle(error: Error, chain: ErrorHandlerChain)
}
