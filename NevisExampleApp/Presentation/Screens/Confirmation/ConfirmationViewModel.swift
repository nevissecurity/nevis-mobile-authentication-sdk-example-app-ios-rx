//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2024 Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication
import RxCocoa
import RxSwift

/// Navigation parameter of the Confirmation view.
enum ConfirmationParameter: NavigationParameterizable {
	/// Represents biometric confirmation case.
	///
	///  - Parameter authenticator: The title of the selected authenticator.
	///  - Parameter handler: The user verification handler.
	case confirmBiometric(authenticator: String, handler: BiometricUserVerificationHandler)

	/// Represents device passcode confirmation case.
	///
	///  - Parameter authenticator: The title of the selected authenticator.
	///  - Parameter handler: The user verification handler.
	case confirmDevicePasscode(authenticator: String, handler: DevicePasscodeUserVerificationHandler)
}

/// View model of Confirmation view.
final class ConfirmationViewModel {

	// MARK: - Properties

	/// The application coordinator.
	private let appCoordinator: AppCoordinator

	/// The selected authenticator.
	private var authenticator: String?

	/// The biometric user verification handler.
	private var biometricUserVerificationHandler: BiometricUserVerificationHandler?

	/// The device passcode user verification handler.
	private var devicePasscodeUserVerificationHandler: DevicePasscodeUserVerificationHandler?

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameters:
	///   - appCoordinator: The application coordinator.
	///   - parameter: The navigation parameter.
	init(appCoordinator: AppCoordinator,
	     parameter: NavigationParameterizable? = nil) {
		self.appCoordinator = appCoordinator
		setParameter(parameter as? ConfirmationParameter)
	}

	/// :nodoc:
	deinit {
		os_log("ConfirmationViewModel", log: OSLog.deinit, type: .debug)
	}
}

// MARK: - Public Interface

extension ConfirmationViewModel: ScreenViewModel {

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
		let title: Driver<String>
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
		let title = Driver.just(L10n.Confirmation.title(authenticator ?? String()))
		let confirm = input.confirmTrigger
			.do(onNext: {
				self.biometricUserVerificationHandler?.verify()
				self.devicePasscodeUserVerificationHandler?.verify()
			})

		let cancel = input.cancelTrigger
			.do(onNext: {
				self.biometricUserVerificationHandler?.cancel()
				self.devicePasscodeUserVerificationHandler?.cancel()
			})

		return Output(title: title,
		              confirm: confirm,
		              cancel: cancel)
	}
}

// MARK: - Private Interface

private extension ConfirmationViewModel {

	/// Handles the recevied parameter.
	///
	/// - Parameter paramter: The parameter to handle.
	func setParameter(_ parameter: ConfirmationParameter?) {
		guard let parameter else {
			preconditionFailure("Parameter type mismatch!")
		}

		switch parameter {
		case let .confirmBiometric(authenticator, handler):
			self.authenticator = authenticator
			biometricUserVerificationHandler = handler
		case let .confirmDevicePasscode(authenticator, handler):
			self.authenticator = authenticator
			devicePasscodeUserVerificationHandler = handler
		}
	}
}
