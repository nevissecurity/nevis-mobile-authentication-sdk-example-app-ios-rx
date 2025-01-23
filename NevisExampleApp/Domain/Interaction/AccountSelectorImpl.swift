//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication

/// Default implementation of `AccountSelector` protocol.
/// For more information about account selection please read the [official documentation](https://docs.nevis.net/mobilesdk/guide/operation/authentication#account-selector).
///
/// First validates the accounts based on policy compliance. Then based on the number of accounts:
///  - if no account is found, the SDK will raise an error.
///  - if one account is found and the transaction confirmation data is present, it emits a ``ConfirmTransactionResponse`` with the help of the ``ResponseEmitter``.
///  - if one account is found and the transaction confirmation data is not present, it performs automatic account selection.
///  - if multiple accounts are found, it emits a ``SelectAccountResponse`` with the help of the ``ResponseEmitter``.
class AccountSelectorImpl {

	// MARK: - Properties

	/// The account validator.
	private let accountValidator: AccountValidator

	/// The response emitter.
	private let responseEmitter: ResponseEmitter

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameters:
	///   - accountValidator: The account validator.
	///   - responseEmitter: The response emitter.
	init(accountValidator: AccountValidator,
	     responseEmitter: ResponseEmitter) {
		self.accountValidator = accountValidator
		self.responseEmitter = responseEmitter
	}
}

// MARK: - AccountSelector

extension AccountSelectorImpl: AccountSelector {
	func selectAccount(context: AccountSelectionContext, handler: AccountSelectionHandler) {
		logger.sdk("Please select one of the received available accounts!")

		do {
			let validAccounts = try accountValidator.validate(context: context)
			switch validAccounts.count {
			case 0:
				// No username is compliant with the policy.
				// Provide a random username that will generate an error in the SDK.
				handler.username("")
			case 1:
				if let transactionConfirmationData = context.transactionConfirmationData,
				   let message = String(data: transactionConfirmationData, encoding: .utf8) {
					let response = ConfirmTransactionResponse(message: message,
					                                          account: validAccounts.first!,
					                                          handler: handler)
					responseEmitter.subject.onNext(response)
				}
				else {
					// Typical case: authentication with username provided, just use it.
					handler.username(validAccounts.first!.username)
				}
			default:
				var transactionConfirmationDataString: String? {
					guard let transactionConfirmationData = context.transactionConfirmationData else {
						return nil
					}

					return String(data: transactionConfirmationData, encoding: .utf8)
				}

				let response = SelectAccountResponse(accounts: validAccounts,
				                                     handler: handler,
				                                     transactionConfirmationData: transactionConfirmationDataString)
				responseEmitter.subject.onNext(response)
			}
		}
		catch {
			logger.sdk("Authenticator selection failed due to %@", .red, .debug, error.localizedDescription)
			handler.cancel()
		}
	}
}
