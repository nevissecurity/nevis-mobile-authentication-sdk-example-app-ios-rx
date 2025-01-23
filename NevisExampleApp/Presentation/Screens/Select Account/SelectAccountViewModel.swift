//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication
import RxCocoa
import RxSwift

/// Navigation parameter of the Select Account view.
enum SelectAccountParameter: NavigationParameterizable {
	/// Represents account selection
	/// .
	///  - Parameters:
	///    - accounts: The list of accounts.
	///    - operation: The ongoing operation.
	///    - handler: The account selection handler.
	///    - message: The message to confirm.
	case select(accounts: [any Account],
	            operation: Operation,
	            handler: AccountSelectionHandler?,
	            message: String?)
}

/// View model of Account Selection view.
final class SelectAccountViewModel {

	// MARK: - Properties

	/// Use case for In-Band authentication.
	private let inBandAuthenticationUseCase: InBandAuthenticationUseCase

	/// Use case for deregistration.
	private let deregistrationUseCase: DeregistrationUseCase

	/// Use case for PIN change.
	private let changePinUseCase: ChangePinUseCase

	/// The response observer.
	private let responseObserver: ResponseObserver

	/// The application coordinator.
	private let appCoordinator: AppCoordinator

	/// The list of accounts.
	private var accounts = [any Account]()

	/// The current operation.
	private var operation: Operation?

	/// The account seelction handler.
	private var handler: AccountSelectionHandler?

	/// The transaction confirmation data.
	private var transactionConfirmationData: String?

	/// The activity indicator.
	private let activityIndicator = ActivityIndicator()

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameters:
	///   - inBandAuthenticationUseCase: Use case for In-Band authentication.
	///   - deregistrationUseCase: Use case for deregistration.
	///   - changePinUseCase: Use case for PIN change.
	///   - responseObserver: The response observer.
	///   - appCoordinator: The application coordinator.
	///   - parameter: The navigation parameter.
	init(inBandAuthenticationUseCase: InBandAuthenticationUseCase,
	     deregistrationUseCase: DeregistrationUseCase,
	     changePinUseCase: ChangePinUseCase,
	     responseObserver: ResponseObserver,
	     appCoordinator: AppCoordinator,
	     parameter: NavigationParameterizable? = nil) {
		self.inBandAuthenticationUseCase = inBandAuthenticationUseCase
		self.deregistrationUseCase = deregistrationUseCase
		self.changePinUseCase = changePinUseCase
		self.responseObserver = responseObserver
		self.appCoordinator = appCoordinator
		setParameter(parameter as? SelectAccountParameter)
	}

	deinit {
		logger.deinit("SelectAccountViewModel")
		// If it is not nil at this moment, it means that a concurrent operation will be started
		handler?.cancel()
	}
}

// MARK: - ScreenViewModel

extension SelectAccountViewModel: ScreenViewModel {

	/// The input of the view model.
	struct Input {
		/// Observable sequence used for starting to load the accounts.
		let loadTrigger: Driver<()>
		/// Observable sequence used for selecting an account at given index path.
		let selectAccount: Driver<any Account>
	}

	/// The output of the view model.
	struct Output {
		/// Observable sequence used for listening to accounts event.
		let accounts: Driver<[any Account]>
		/// Observable sequence used for listening to account selection event.
		let selection: Driver<()>
		/// Observable sequence used for listening to loading events.
		let loading: Driver<Bool>
		/// Observable sequence used for listening to error events.
		let error: Driver<Error>
	}

	/// Performs pure transformation of a user `Input` to the `Output`.
	///
	/// - Parameter input: The input need to be transformed.
	/// - Returns: The transformed output.
	func transform(input: Input) -> Output {
		let errorTracker = ErrorTracker()

		let accounts = input.loadTrigger
			.flatMapLatest { [unowned self] _ in
				Driver.just(self.accounts)
			}

		let selection = input.selectAccount
			.asObservable()
			.flatMap(handle(account:))
			.trackError(errorTracker)
			.asDriverOnErrorJustComplete()

		let loading = activityIndicator.asDriver()
		let error = errorTracker.asDriver()
		return Output(accounts: accounts,
		              selection: selection,
		              loading: loading,
		              error: error)
	}
}

// MARK: - Actions

private extension SelectAccountViewModel {

	/// Handles the recevied parameter.
	///
	/// - Parameter paramter: The parameter to handle.
	func setParameter(_ parameter: SelectAccountParameter?) {
		guard let parameter else {
			preconditionFailure("Parameter type mismatch!")
		}

		switch parameter {
		case let .select(accounts, operation, handler, transactionConfirmationData):
			self.accounts = accounts
			self.operation = operation
			self.handler = handler
			self.transactionConfirmationData = transactionConfirmationData
		}
	}

	/// Handles the selected account.
	///
	/// - Parameter account: The selected account to handle.
	/// - Returns:An observable sequence.
	func handle(account: any Account) -> Observable<()> {
		if let transactionConfirmationData {
			// Transaction confirmation data is received from the SDK
			// Show it to the user for confirmation or cancellation
			// The AccountSelectionHandler will be invoked or cancelled there.
			let parameter: TransactionConfirmationParameter = .confirm(message: transactionConfirmationData,
			                                                           account: account,
			                                                           handler: handler!)
			handler = nil
			return .just(appCoordinator.navigateToTransactionConfirmation(with: parameter))
		}

		switch operation {
		case .authentication:
			// in-band authentication is in progress (arriving from the Home screen)
			return inBandAuthenticationUseCase.execute(username: account.username, operation: operation!)
				.flatMap(responseObserver.observe(response:))
		case .deregistration:
			// deregistration (Identity Suite env) is in progress where the deregistration endpoint is guarded,
			// so an authorization provider is needed.
			// First perform in-band authentication then a deregistration with the username.
			return inBandAuthenticationUseCase.execute(username: account.username, operation: operation!)
				.flatMap { response -> Observable<OperationResponse> in
					guard let response = response as? CompletedResponse,
					      let authorizationProvider = response.authorizationProvider else {
						return .error(AppError.cookieNotFound)
					}

					return self.deregistrationUseCase.execute(usernames: [account.username],
					                                          authorizationProvider: authorizationProvider)
				}
				.flatMap(responseObserver.observe(response:))
		case .pinChange:
			return changePinUseCase.execute(username: account.username)
				.flatMap(responseObserver.observe(response:))
		default:
			return select(account: account)
		}
	}

	/// Invokes the account selection handler.
	///
	/// - Parameter account: The selected account to handle.
	/// - Returns:An observable sequence.
	func select(account: any Account) -> Observable<()> {
		Observable.create {
			self.handler?.username(account.username)
			self.handler = nil
			$0.onNext(())
			$0.onCompleted()
			return Disposables.create()
		}
	}
}
