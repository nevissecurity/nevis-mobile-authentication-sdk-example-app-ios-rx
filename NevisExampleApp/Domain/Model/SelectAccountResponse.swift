//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication

/// Response class indicating the SDK operation asks the user to select one of the available accounts.
final class SelectAccountResponse: OperationResponse {

	// MARK: - Properties

	/// The list of available accounts.
	let accounts: [any Account]

	/// The object that is notified of the selection result.
	let handler: AccountSelectionHandler

	/// The transaction confirmation data, if any, to be presented to the user for verification.
	let transactionConfirmationData: String?

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameters:
	///   - accounts: The list of available accounts.
	///   - handler: The object that is notified of the selection result.
	///   - transactionConfirmationData: The transaction confirmation data, if any, to be presented to the user for verification.
	init(accounts: [any Account],
	     handler: AccountSelectionHandler,
	     transactionConfirmationData: String?) {
		self.accounts = accounts
		self.handler = handler
		self.transactionConfirmationData = transactionConfirmationData
		super.init()
	}
}
