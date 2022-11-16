//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import Foundation

/// Represents Pin protection related information that is used by the PinScreen view.
struct PinProtectionInformation {

	// MARK: - Properties

	/// Pin protection related message.
	let message: String

	/// Flag that tells whether the authenticator is in cooldown.
	let isInCoolDown: Bool

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameters:
	///   - message: Pin protection related message. Default value is an empty string.
	///   - isInCoolDown: Flag that tells whether the authenticator is in cooldown. Default value is false.
	init(message: String = "", isInCoolDown: Bool = false) {
		self.message = message
		self.isInCoolDown = isInCoolDown
	}
}
