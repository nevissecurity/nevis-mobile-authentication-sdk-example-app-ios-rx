//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

/// By conforming to the protocol means that a view model will be belong to  the instance.
protocol Screen {

	/// Associated type for the view model.
	associatedtype ViewModelType

	/// The view model that belongs to the screen.
	var viewModel: ViewModelType! { get set }

	/// Refreshes the screen.
	func refresh()
}
