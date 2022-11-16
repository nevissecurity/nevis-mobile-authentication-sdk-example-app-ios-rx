//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication

/// Response class indicating that the previously started operation successfully completed.
final class CompletedResponse: OperationResponse {

	// MARK: - Properties

	/// The related operation.
	let operation: Operation

	/// Object providing credentials required to perform authorization, if the FIDO UAF endpoint is protected and requires authorization.
	var authorizationProvider: AuthorizationProvider?

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameters:
	///   - operation: The related operation.
	///   - authorizationProvider: Object providing credentials required to perform authorization, if the FIDO UAF endpoint is protected and requires authorization.
	init(operation: Operation, authorizationProvider: AuthorizationProvider? = nil) {
		self.operation = operation
		self.authorizationProvider = authorizationProvider
		super.init()
	}
}
