//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication
import RxCocoa
import RxSwift

/// View model of Username Password Login view.
final class UsernamePasswordLoginViewModel {

	// MARK: - Properties

	/// The configuration loader.
	private let configurationLoader: ConfigurationLoader

	/// Use case for login.
	private let loginUseCase: LoginUseCase

	/// Use case for registration.
	private let registrationUseCase: RegistrationUseCase

	/// The response observer.
	private let responseObserver: ResponseObserver

	/// The application coordinator.
	private let appCoordinator: AppCoordinator

	/// The activity indicator.
	private let activityIndicator = ActivityIndicator()

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameters:
	///   - configurationLoader: The configuration loader.
	///   - loginUseCase: Use case for login.
	///   - registrationUseCase: Use case for registration.
	///   - responseObserver: The response observer.
	///   - appCoordinator: The application coordinator.
	init(configurationLoader: ConfigurationLoader,
	     loginUseCase: LoginUseCase,
	     registrationUseCase: RegistrationUseCase,
	     responseObserver: ResponseObserver,
	     appCoordinator: AppCoordinator) {
		self.configurationLoader = configurationLoader
		self.loginUseCase = loginUseCase
		self.registrationUseCase = registrationUseCase
		self.responseObserver = responseObserver
		self.appCoordinator = appCoordinator
	}

	deinit {
		logger.deinit("UsernamePasswordLoginViewModel")
	}
}

// MARK: - ScreenViewModel

extension UsernamePasswordLoginViewModel: ScreenViewModel {

	/// The input of the view model.
	struct Input {
		/// Observable sequence used for listening to username.
		let username: Driver<String>
		/// Observable sequence used for listening to password.
		let password: Driver<String>
		/// Observable sequence used for starting confirmation.
		let confirmTrigger: Driver<()>
		/// Observable sequence used for starting cancellation.
		let cancelTrigger: Driver<()>
	}

	/// The output of the view model.
	struct Output {
		/// Observable sequence used for listening to confirm event.
		let confirm: Driver<()>
		/// Observable sequence used for listening to cancel event.
		let cancel: Driver<()>
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

		let inputData = Driver.combineLatest(input.username, input.password)
		let confirm = input.confirmTrigger
			.withLatestFrom(inputData)
			.asObservable()
			.flatMap(login(_:_:))
			.flatMap(register(using:))
			.trackError(errorTracker)
			.asDriverOnErrorJustComplete()

		let cancel = input.cancelTrigger
			.do(onNext: appCoordinator.start)

		let loading = activityIndicator.asDriver()
		let error = errorTracker.asDriver()
		return Output(confirm: confirm,
		              cancel: cancel,
		              loading: loading,
		              error: error)
	}
}

private extension UsernamePasswordLoginViewModel {

	/// Starts login.
	///
	/// - Parameters:
	///   - username: The username.
	///   - password: The password.
	/// - Returns: An observable sequence that will emit a ``Credentials`` object.
	func login(_ username: String, _ password: String) -> Observable<Credentials> {
		configurationLoader.load()
			.flatMap { configuration -> Observable<Credentials> in
				guard let url = URL(string: configuration.loginConfiguration.loginRequestURL) else {
					return .error(OperationError(operation: .registration,
					                             underlyingError: AppError.readLoginConfigurationError))
				}

				return self.loginUseCase.execute(url: url,
				                                 username: username,
				                                 password: password)
					.trackActivity(self.activityIndicator)
			}
	}

	/// Starts In-Band registration.
	///
	/// - Parameter credentials: The credentials.
	/// - Returns: An observable sequence.
	func register(using credentials: Credentials) -> Observable<()> {
		guard let cookies = credentials.cookies, !cookies.isEmpty else {
			return .error(OperationError(operation: .registration,
			                             underlyingError: AppError.cookieNotFound))
		}
		let authorizationProvider = CookieAuthorizationProvider(cookies)
		return registrationUseCase.execute(username: credentials.username,
		                                   authorizationProvider: authorizationProvider)
			.flatMap(responseObserver.observe(response:))
			.trackActivity(activityIndicator)
	}
}
