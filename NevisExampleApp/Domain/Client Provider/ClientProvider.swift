//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication

/// Protocol declaration for handling an instance of `MobileAuthenticationClient`.
protocol ClientProvider {

	/// Saves the given client instance.
	///
	/// - Parameter client: The client instance to save.
	func save(client: MobileAuthenticationClient)

	/// Returns a client or `nil`.
	///
	/// - Returns: An optional `MobileAuthenticationClient` instance.
	func get() -> MobileAuthenticationClient?

	/// Resets the state of the provider.
	func reset()
}
