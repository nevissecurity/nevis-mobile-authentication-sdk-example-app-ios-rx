//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication

/// Response class indicating that the previously started operation successfully completed.
final class ConfirmTransactionResponse: OperationResponse {

	// MARK: - Properties

	/// The transaction confirmation data.
	let message: String

	/// The selected account.
	let account: Account

	/// The object that is notified of the account selection result.
	let handler: AccountSelectionHandler

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameters:
	///   - message: The transaction confirmation data.
	///   - account: The selected account.
	///   - handler: The object that is notified of the account selection result.
	init(message: String,
	     account: Account,
	     handler: AccountSelectionHandler) {
		self.message = message
		self.account = account
		self.handler = handler
		super.init()
	}
}
