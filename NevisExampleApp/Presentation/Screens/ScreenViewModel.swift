//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

/// Describes general view model related operations.
protocol ScreenViewModel {

	/// Associated type for the input of the view model.
	associatedtype Input

	/// Associated type for the output of the view model.
	associatedtype Output

	/// Performs pure transformation of a user `Input` to the `Output`.
	///
	/// - parameter input: The input need to be transformed.
	/// - returns: The transformed output.
	func transform(input: Input) -> Output
}
