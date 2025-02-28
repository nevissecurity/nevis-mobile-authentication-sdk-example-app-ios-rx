//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import RxCocoa
import RxSwift

/// View model of Auth Cloud Api Registration view.
final class AuthCloudApiRegistrationViewModel {
	// MARK: - Properties

	/// Use case for Auth Cloud Api registration.
	private let authCloudApiRegistrationUseCase: AuthCloudApiRegistrationUseCase

	/// The response observer.
	private let responseObserver: ResponseObserver

	/// The application coordinator.
	private let appCoordinator: AppCoordinator

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameters:
	///   - authCloudApiRegistrationUseCase: Use case for Auth Cloud Api registration.
	///   - responseObserver: The response observer.
	///   - appCoordinator: The application coordinator.
	init(authCloudApiRegistrationUseCase: AuthCloudApiRegistrationUseCase,
	     responseObserver: ResponseObserver,
	     appCoordinator: AppCoordinator) {
		self.authCloudApiRegistrationUseCase = authCloudApiRegistrationUseCase
		self.responseObserver = responseObserver
		self.appCoordinator = appCoordinator
	}

	deinit {
		logger.deinit("AuthCloudApiRegistrationViewModel")
	}
}

// MARK: - ScreenViewModel

extension AuthCloudApiRegistrationViewModel: ScreenViewModel {

	/// The input of the view model.
	struct Input {
		/// Observable sequence used for listening to enroll response.
		let enrollResponse: Driver<String?>
		/// Observable sequence used for listening to app link URI.
		let appLinkUri: Driver<String?>
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
		/// Observable sequence used for listening to error events.
		let validationError: Driver<String>
		/// Observable sequence used for listening to error events.
		let error: Driver<Error>
	}

	/// Performs pure transformation of a user `Input` to the `Output`.
	///
	/// - Parameter input: The input need to be transformed.
	/// - Returns: The transformed output.
	func transform(input: Input) -> Output {
		let errorTracker = ErrorTracker()

		let inputData = Driver.combineLatest(input.enrollResponse, input.appLinkUri)
		let validator = AuthCloudApiRegistrationValidator()
		let confirmPinValidation = Driver.combineLatest(inputData, input.confirmTrigger)
			.map(\.0)
			.map(validator.validate(_:_:))
		let validationError = confirmPinValidation.map(\.message)

		let confirm = input.confirmTrigger
			.withLatestFrom(confirmPinValidation.map(\.isValid).startWith(true))
			.filter(\.self)
			.withLatestFrom(inputData)
			.asObservable()
			.flatMapLatest { enrollResponse, appLinkUri in
				self.authCloudApiRegistrationUseCase.execute(enrollResponse: enrollResponse,
				                                             appLinkUri: appLinkUri)
					.trackError(errorTracker)
					.flatMap(self.responseObserver.observe(response:))
			}
			.asDriverOnErrorJustComplete()

		let cancel = input.cancelTrigger
			.do(onNext: appCoordinator.start)

		let error = errorTracker.asDriver()
		return Output(confirm: confirm,
		              cancel: cancel,
		              validationError: validationError,
		              error: error)
	}
}
