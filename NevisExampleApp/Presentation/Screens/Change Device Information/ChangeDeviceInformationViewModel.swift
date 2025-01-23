//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication
import RxCocoa
import RxSwift

/// Navigation parameter of the Change Device Information view.
enum ChangeDeviceInformationParameter: NavigationParameterizable {
	/// Represents change device information.
	///
	///  - Parameter deviceInformation: The current device information.
	case change(deviceInformation: DeviceInformation)
}

/// View model of Change Device Information view.
final class ChangeDeviceInformationViewModel {
	// MARK: - Properties

	/// Use case for change device information.
	private let changeDeviceInformationUseCase: ChangeDeviceInformationUseCase

	/// The response observer.
	private let responseObserver: ResponseObserver

	/// The application coordinator.
	private let appCoordinator: AppCoordinator

	/// The current device information.
	private var deviceInformation: DeviceInformation?

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameters:
	///   - changeDeviceInformationUseCase: Use case for change device information.
	///   - responseObserver: The response observer.
	///   - appCoordinator: The application coordinator.
	///   - parameter: The navigation parameter.
	init(changeDeviceInformationUseCase: ChangeDeviceInformationUseCase,
	     responseObserver: ResponseObserver,
	     appCoordinator: AppCoordinator,
	     parameter: NavigationParameterizable? = nil) {
		self.changeDeviceInformationUseCase = changeDeviceInformationUseCase
		self.responseObserver = responseObserver
		self.appCoordinator = appCoordinator
		setParameter(parameter as? ChangeDeviceInformationParameter)
	}

	deinit {
		logger.deinit("ChangeDeviceInformationViewModel")
	}
}

// MARK: - ScreenViewModel

extension ChangeDeviceInformationViewModel: ScreenViewModel {

	/// The input of the view model.
	struct Input {
		/// Observable sequence used for starting initialization related operations.
		let loadTrigger: Driver<()>
		/// Observable sequence used for listening to Pin confirmation.
		let name: Driver<String>
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
		let activityIndicator = ActivityIndicator()
		let errorTracker = ErrorTracker()
		let description = Driver.just(L10n.ChangeDeviceInformation.currentName(deviceInformation!.name))

		let confirm = input.confirmTrigger
			.withLatestFrom(input.name)
			.asObservable()
			.flatMapLatest {
				self.changeDeviceInformationUseCase.execute(name: $0,
				                                            fcmRegistrationToken: nil,
				                                            disablePushNotifications: nil)
					.flatMap(self.responseObserver.observe(response:))
					.trackActivity(activityIndicator)
					.trackError(errorTracker)
			}
			.asDriverOnErrorJustComplete()

		let cancel = input.cancelTrigger
			.do(onNext: appCoordinator.start)

		let loading = activityIndicator.asDriver()
		let error = errorTracker.asDriver()
		return Output(description: description,
		              confirm: confirm,
		              cancel: cancel,
		              loading: loading,
		              error: error)
	}
}

// MARK: - Actions

private extension ChangeDeviceInformationViewModel {

	/// Handles the recevied parameter.
	///
	/// - Parameter paramter: The parameter to handle.
	func setParameter(_ parameter: ChangeDeviceInformationParameter?) {
		guard let parameter else {
			preconditionFailure("Parameter type mismatch!")
		}

		switch parameter {
		case let .change(deviceInformation):
			self.deviceInformation = deviceInformation
		}
	}
}
