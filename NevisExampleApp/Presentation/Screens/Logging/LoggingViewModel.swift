//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import RxCocoa

/// View model of Logging view.
final class LoggingViewModel {

	// MARK: - Initialization

	/// Creates a new instance.
	init() {}
}

// MARK: - ScreenViewModel

extension LoggingViewModel: ScreenViewModel {

	/// The input of the view model.
	struct Input {}

	/// The output of the view model.
	struct Output {
		/// Observable sequence used for listening to logging events.
		let logs: Driver<NSAttributedString>
	}

	/// Performs pure transformation of a user `Input` to the `Output`.
	///
	/// - Parameter input: The input need to be transformed.
	/// - Returns: The transformed output.
	func transform(input _: Input) -> Output {
		let logs = logger.asObservable()
			.asDriverOnErrorJustComplete()

		return Output(logs: logs)
	}
}
