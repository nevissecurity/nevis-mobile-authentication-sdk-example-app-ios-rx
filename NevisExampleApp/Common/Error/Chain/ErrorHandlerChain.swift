//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import Foundation

/// The chain implementation is used to provide the other error handlers for the current ``ErrorHandler``.
protocol ErrorHandlerChain {

	/// Handles the given error.
	///
	/// - Parameter error: The error to handle.
	func handle(error: Error)
}
