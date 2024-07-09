//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication
import RxCocoa
import RxSwift

/// View model of Home view.
final class HomeViewModel {

	// MARK: - Properties

	/// The configuration loader.
	private let configurationLoader: ConfigurationLoader

	/// Use case for initializing the client.
	private let initClientUseCase: InitClientUseCase

	/// Use case for deregistration.
	private let deregistrationUseCase: DeregistrationUseCase

	/// Use case for PIN change.
	private let changePinUseCase: ChangePinUseCase

	/// Use case for Password change.
	private let changePasswordUseCase: ChangePasswordUseCase

	/// Use case for retrieving the accounts.
	private let getAccountsUseCase: GetAccountsUseCase

	/// Use case for retrieving the authenticators.
	private let getAuthenticatorsUseCase: GetAuthenticatorsUseCase

	/// Use case for deleting local authenticators.
	private let deleteAuthenticatorsUseCase: DeleteAuthenticatorsUseCase

	/// Use case for retrieving the device information.
	private let getDeviceInformationUseCase: GetDeviceInformationUseCase

	/// The response observer.
	private let responseObserver: ResponseObserver

	/// The application coordinator.
	private let appCoordinator: AppCoordinator

	/// The activitiy indicator.
	private let activityIndicator = ActivityIndicator()

	/// The error tracker.
	private let errorTracker = ErrorTracker()

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameters:
	///   - configurationLoader: The configuration loader.
	///   - initClientUseCase: Use case for initializing the client.
	///   - deregistrationUseCase: Use case for deregistration.
	///   - changePinUseCase: Use case for PIN change.
	///   - changePasswordUseCase: Use case for Password change.
	///   - getAccountsUseCase: Use case for retrieving the accounts.
	///   - getAuthenticatorsUseCase: Use case for retrieving the authenticators.
	///   - deleteAuthenticatorsUseCase: Use case for deleting local authenticators.
	///   - getDeviceInformationUseCase: Use case for retrieving the device information.
	///   - responseObserver: The response observer.
	///   - appCoordinator: The application coordinator.
	init(configurationLoader: ConfigurationLoader,
	     initClientUseCase: InitClientUseCase,
	     deregistrationUseCase: DeregistrationUseCase,
	     changePinUseCase: ChangePinUseCase,
	     changePasswordUseCase: ChangePasswordUseCase,
	     getAccountsUseCase: GetAccountsUseCase,
	     getAuthenticatorsUseCase: GetAuthenticatorsUseCase,
	     deleteAuthenticatorsUseCase: DeleteAuthenticatorsUseCase,
	     getDeviceInformationUseCase: GetDeviceInformationUseCase,
	     responseObserver: ResponseObserver,
	     appCoordinator: AppCoordinator) {
		self.configurationLoader = configurationLoader
		self.initClientUseCase = initClientUseCase
		self.deregistrationUseCase = deregistrationUseCase
		self.changePinUseCase = changePinUseCase
		self.changePasswordUseCase = changePasswordUseCase
		self.getAccountsUseCase = getAccountsUseCase
		self.getAuthenticatorsUseCase = getAuthenticatorsUseCase
		self.deleteAuthenticatorsUseCase = deleteAuthenticatorsUseCase
		self.getDeviceInformationUseCase = getDeviceInformationUseCase
		self.responseObserver = responseObserver
		self.appCoordinator = appCoordinator
	}

	/// :nodoc:
	deinit {
		os_log("HomeViewModel", log: OSLog.deinit, type: .debug)
	}
}

// MARK: - ScreenViewModel

extension HomeViewModel: ScreenViewModel {

	/// The input of the view model.
	struct Input {
		/// Observable sequence used for starting initialization related operations.
		let loadTrigger: Driver<()>
		/// Observable sequence used for start reading Qr Code.
		let readQrCodeTrigger: Driver<()>
		/// Observable sequence used for starting in-band authentication.
		let authenticateTrigger: Driver<()>
		/// Observable sequence used for starting deregistration.
		let deregisterTrigger: Driver<()>
		/// Observable sequence used for starting PIN change.
		let pinChangeTrigger: Driver<()>
		/// Observable sequence used for starting Password change.
		let passwordChangeTrigger: Driver<()>
		/// Observable sequence used for starting device information change.
		let changeDeviceInformationTrigger: Driver<()>
		/// Observable sequence used for starting auth cloud api registration.
		let authCloudApiRegistrationTrigger: Driver<()>
		/// Observable sequence used for starting authenticators deletion.
		let deleteAuthenticatorsTrigger: Driver<()>
		/// Observable sequence used for starting in-band registration.
		let inBandRegistrationTrigger: Driver<()>
	}

	/// The output of the view model.
	struct Output {
		/// Observable sequence used for listening to authenticate event.
		let initClient: Driver<()>
		/// Observable sequence used for listening to registered accounts event.
		let accounts: Driver<[any Account]>
		/// Observable sequence used for listening to Qr Code read event.
		let readQrCode: Driver<()>
		/// Observable sequence used for listening to authenticate event.
		let authenticate: Driver<()>
		/// Observable sequence used for listening to deregister event.
		let deregister: Driver<()>
		/// Observable sequence used for listening to PIN change event.
		let pinChange: Driver<()>
		/// Observable sequence used for listening to Password change event.
		let passwordChange: Driver<()>
		/// Observable sequence used for listening to deregister event.
		let changeDeviceInformation: Driver<()>
		/// Observable sequence used for listening to auth cloud api registration event.
		let authCloudApiRegistration: Driver<()>
		/// Observable sequence used for listening to authenticators deletion event.
		let deleteAuthenticators: Driver<()>
		/// Observable sequence used for listening to in-band registration event.
		let inBandRegistration: Driver<()>
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
		let initClient = input.loadTrigger
			.asObservable()
			.flatMapLatest(configurationLoader.load)
			.map(\.sdkConfiguration)
			.flatMap(initClientUseCase.execute(configuration:))
			.trackError(errorTracker)
			.asDriverOnErrorJustComplete()

		let accounts = input.loadTrigger
			.asObservable()
			.flatMapLatest(getAccountsUseCase.execute)
			.asDriverOnErrorJustComplete()

		let readQrCode = input.readQrCodeTrigger
			.do(onNext: appCoordinator.navigateToQrScanner)

		let authenticate = input.authenticateTrigger
			.asObservable()
			.flatMapLatest(getAccountsUseCase.execute)
			.flatMap(authenticate(with:))
			.trackError(errorTracker)
			.asDriverOnErrorJustComplete()

		let deregister = input.deregisterTrigger
			.asObservable()
			.flatMapLatest(deregister)
			.asDriverOnErrorJustComplete()

		let pinChange = input.pinChangeTrigger
			.asObservable()
			.flatMapLatest(changePin)
			.trackError(errorTracker)
			.asDriverOnErrorJustComplete()

		let passwordChange = input.passwordChangeTrigger
			.asObservable()
			.flatMapLatest(changePassword)
			.trackError(errorTracker)
			.asDriverOnErrorJustComplete()

		let changeDeviceInformation = input.changeDeviceInformationTrigger
			.asObservable()
			.flatMapLatest(changeDeviceInformation)
			.asDriverOnErrorJustComplete()

		let authCloudApiRegistration = input.authCloudApiRegistrationTrigger
			.do(onNext: appCoordinator.navigateToAuthCloudApiRegistration)

		let deleteAuthenticators = input.deleteAuthenticatorsTrigger
			.asObservable()
			.flatMapLatest(getAccountsUseCase.execute)
			.flatMapLatest(deleteAuthenticatorsUseCase.execute)
			.flatMap(responseObserver.observe(response:))
			.trackError(errorTracker)
			.asDriverOnErrorJustComplete()

		let inBandRegistration = input.inBandRegistrationTrigger
			.do(onNext: appCoordinator.navigateToUsernamePasswordLogin)

		let loading = activityIndicator.asDriver()
		let error = errorTracker.asDriver()
		return Output(initClient: initClient,
		              accounts: accounts,
		              readQrCode: readQrCode,
		              authenticate: authenticate,
		              deregister: deregister,
		              pinChange: pinChange,
		              passwordChange: passwordChange,
		              changeDeviceInformation: changeDeviceInformation,
		              authCloudApiRegistration: authCloudApiRegistration,
		              deleteAuthenticators: deleteAuthenticators,
		              inBandRegistration: inBandRegistration,
		              loading: loading,
		              error: error)
	}
}

private extension HomeViewModel {

	/// Starts In-Band authentication.
	///
	/// - Parameter accounts: The list of the available accounts.
	/// - Returns: An observable sequence.
	func authenticate(with accounts: [any Account]) -> Observable<()> {
		guard !accounts.isEmpty else {
			return .error(BusinessError.accountsNotFound)
		}

		let parameter: SelectAccountParameter = .select(accounts: accounts,
		                                                operation: .authentication,
		                                                handler: nil,
		                                                message: nil)
		return .just(appCoordinator.navigateToAccountSelection(with: parameter))
	}

	/// Starts deregistration.
	///
	/// - Returns: An observable sequence.
	func deregister() -> Observable<()> {
		switch configurationLoader.environment {
		case .authenticationCloud:
			deregistrationUseCase.execute(username: nil,
			                              authorizationProvider: nil)
				.flatMap(responseObserver.observe(response:))
				.trackActivity(activityIndicator)
				.trackError(errorTracker)
		case .identitySuite:
			// In the Identity Suite environment the deregistration endpoint is guarded,
			// and as such we need to provide a cookie to the deregister call.
			// Also in Identity Siute a deregistration has to be authenticated for every user,
			// so batch deregistration is not really possible.
			getAccountsUseCase.execute()
				.flatMap {
					let parameter: SelectAccountParameter = .select(accounts: $0,
					                                                operation: .deregistration,
					                                                handler: nil,
					                                                message: nil)
					return Observable.just(self.appCoordinator.navigateToAccountSelection(with: parameter))
				}
		}
	}

	/// Starts PIN changing.
	///
	/// - Returns: An observable sequence.
	func changePin() -> Observable<()> {
		Observable.combineLatest(getSdkEnrollment(for: .Pin),
		                         getAccountsUseCase.execute())
			.flatMap { enrollment, accounts -> Observable<()> in
				let eligibleAccounts = accounts.filter { account in
					enrollment.enrolledAccounts.contains { enrolledAccount in
						enrolledAccount.username == account.username
					}
				}

				switch eligibleAccounts.count {
				case 0:
					return .error(BusinessError.accountsNotFound)
				case 1:
					// in case of one account we can select it automatically
					return self.changePinUseCase.execute(username: eligibleAccounts.first!.username)
						.flatMap(self.responseObserver.observe(response:))
				default:
					// in case of multiple eligible accounts we have to show the account selection screen
					let parameter: SelectAccountParameter = .select(accounts: eligibleAccounts,
					                                                operation: .pinChange,
					                                                handler: nil,
					                                                message: nil)
					return .just(self.appCoordinator.navigateToAccountSelection(with: parameter))
				}
			}
	}

	/// Starts Password changing.
	///
	/// - Returns: An observable sequence.
	func changePassword() -> Observable<()> {
		Observable.combineLatest(getSdkEnrollment(for: .Password),
		                         getAccountsUseCase.execute())
			.flatMap { enrollment, accounts -> Observable<()> in
				let eligibleAccounts = accounts.filter { account in
					enrollment.enrolledAccounts.contains { enrolledAccount in
						enrolledAccount.username == account.username
					}
				}

				switch eligibleAccounts.count {
				case 0:
					return .error(BusinessError.accountsNotFound)
				case 1:
					// in case of one account we can select it automatically
					return self.changePasswordUseCase.execute(username: eligibleAccounts.first!.username)
						.flatMap(self.responseObserver.observe(response:))
				default:
					// in case of multiple eligible accounts we have to show the account selection screen
					let parameter: SelectAccountParameter = .select(accounts: eligibleAccounts,
					                                                operation: .passwordChange,
					                                                handler: nil,
					                                                message: nil)
					return .just(self.appCoordinator.navigateToAccountSelection(with: parameter))
				}
			}
	}

	/// Fetching the SDK managed authenticator enrollments.
	///
	/// - Parameter authenticator: The SDK managed authenticator.
	/// - Returns: An observable sequence that will emit an ``SdkUserEnrollment`` object.
	func getSdkEnrollment(for authenticator: AuthenticatorAaid) -> Observable<SdkUserEnrollment> {
		let error = switch authenticator {
		case .Password: AppError.passwordAuthenticatorNotFound
		case .Pin: AppError.pinAuthenticatorNotFound
		default: AppError.unknown
		}

		return getAuthenticatorsUseCase.execute()
			.flatMap { authenticators -> Observable<SdkUserEnrollment> in
				// searching for the given authenticator
				guard let credentialAuthenticator = authenticators.filter({ $0.aaid == authenticator.rawValue }).first else {
					return .error(error)
				}

				guard let enrollment = credentialAuthenticator.userEnrollment as? SdkUserEnrollment else {
					return .error(error)
				}

				return .just(enrollment)
			}
	}

	/// Starts changing the device information.
	///
	/// - Returns: An observable sequence.
	func changeDeviceInformation() -> Observable<()> {
		getDeviceInformationUseCase.execute()
			.flatMap {
				let parameter: ChangeDeviceInformationParameter = .change(deviceInformation: $0)
				return Observable.just(self.appCoordinator.navigateToChangeDeviceInformation(with: parameter))
			}
			.trackActivity(activityIndicator)
			.trackError(errorTracker)
	}
}
