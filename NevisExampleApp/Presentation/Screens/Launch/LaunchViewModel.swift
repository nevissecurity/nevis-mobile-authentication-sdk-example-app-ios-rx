//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

/// View model of Launch view.
final class LaunchViewModel {}

// MARK: - ScreenViewModel

extension LaunchViewModel: ScreenViewModel {

	/// The input of the view model.
	struct Input {}

	/// The output of the view model.
	struct Output {}

	/// Performs pure transformation of a user `Input` to the `Output`.
	///
	/// - parameter input: The input need to be transformed.
	/// - returns: The transformed output.
	func transform(input _: Input) -> Output {
		Output()
	}
}
