//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import RxCocoa

/// View model of Not Enrolled Authenticator view.
final class NotEnrolledAuthenticatorViewModel {

	// MARK: - Properties

	/// The application coordinator.
	private let coordinator: AppCoordinator

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameter appCoordinator: The application coordinator.
	init(coordinator: AppCoordinator) {
		self.coordinator = coordinator
	}
}

// MARK: - ScreenViewModel

extension NotEnrolledAuthenticatorViewModel: ScreenViewModel {

	/// The input of the view model.
	struct Input {
		/// Observable sequence used for handling the action.
		let actionTrigger: Driver<()>
	}

	/// The output of the view model.
	struct Output {
		/// Observable sequence used for listening to action event.
		let action: Driver<()>
	}

	/// Performs pure transformation of a user `Input` to the `Output`.
	///
	/// - Parameter input: The input need to be transformed.
	/// - Returns: The transformed output.
	func transform(input: Input) -> Output {
		let action = input.actionTrigger
			.do(onNext: {
				self.coordinator.start()
				UIApplication.shared.openSystemSettings()
			})

		return Output(action: action)
	}
}
