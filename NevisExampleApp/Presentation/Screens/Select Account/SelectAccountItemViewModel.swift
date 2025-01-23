//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication

/// View model of a cell that displaying information about an available authenticator.
struct SelectAccountItemViewModel {

	// MARK: - Properties

	/// The readable title.
	let title: String

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameter account: The account.
	init(account: any Account) {
		self.title = account.username
	}
}
