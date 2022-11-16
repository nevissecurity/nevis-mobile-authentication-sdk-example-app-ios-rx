//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication
import RxCocoa
import RxSwift

/// Navigation parameter of the Transaction Confirmation view.
enum TransactionConfirmationParameter: NavigationParameterizable {
	/// Represents transaction confirmation.
	///
	///  - Parameters:
	///    - message: The message to confirm.
	///    - account: The previously selected account.
	///    - handler: The account selection handler.
	case confirm(message: String, account: Account, handler: AccountSelectionHandler)
}

/// View model of Transaction Confirmation view.
final class TransactionConfirmationViewModel {

	// MARK: - Properties

	/// The logger.
	private let logger: SDKLogger

	/// The transaction confirmation message.
	private var message: String?

	/// The previously selected account.
	private var account: Account?

	/// The account selection handler.
	private var handler: AccountSelectionHandler?

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameters:
	///   - logger: The logger.
	///   - parameter: The navigation parameter.
	init(logger: SDKLogger,
	     parameter: NavigationParameterizable? = nil) {
		self.logger = logger
		setParameter(parameter as? TransactionConfirmationParameter)
	}

	/// :nodoc:
	deinit {
		os_log("TransactionConfirmationViewModel", log: OSLog.deinit, type: .debug)
		// If it is not nil at this moment, it means that a concurrent operation will be started
		handler?.cancel()
	}
}

// MARK: - ScreenViewModel

extension TransactionConfirmationViewModel: ScreenViewModel {

	/// The input of the view model.
	struct Input {
		/// Observable sequence used for starting confirmation.
		let confirmTrigger: Driver<()>
		/// Observable sequence used for starting cancellation.
		let cancelTrigger: Driver<()>
	}

	/// The output of the view model.
	struct Output {
		/// Observable sequence used for listening to actual description.
		let description: Driver<String>
		/// Observable sequence used for listening to confirm event.
		let confirm: Driver<()>
		/// Observable sequence used for listening to cancel event.
		let cancel: Driver<()>
	}

	/// Performs pure transformation of a user `Input` to the `Output`.
	///
	/// - Parameter input: The input need to be transformed.
	/// - Returns: The transformed output.
	func transform(input: Input) -> Output {
		let description = Driver.just(message!)
		let confirm = input.confirmTrigger
			.do(onNext: {
				self.handler?.username(self.account!.username)
				self.handler = nil
			})

		let cancel = input.cancelTrigger
			.do(onNext: { self.handler?.cancel() })

		return Output(description: description,
		              confirm: confirm,
		              cancel: cancel)
	}
}

// MARK: - Actions

private extension TransactionConfirmationViewModel {

	/// Handles the recevied parameter.
	///
	/// - Parameter paramter: The parameter to handle.
	func setParameter(_ parameter: TransactionConfirmationParameter?) {
		guard let parameter = parameter else {
			preconditionFailure("Parameter type mismatch!")
		}

		switch parameter {
		case let .confirm(message, account, handler):
			self.message = message
			self.account = account
			self.handler = handler
		}
	}
}
