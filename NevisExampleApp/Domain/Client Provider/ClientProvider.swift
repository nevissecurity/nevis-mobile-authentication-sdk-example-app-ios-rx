//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication
import RxSwift

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

	/// Returns a hot `BehaviorSubject` that emits the current `MobileAuthenticationClient` (or `nil`)
	/// and all subsequent updates.
	///
	/// Use this to observe client availability (e.g. to trigger work after initialization).
	/// A `BehaviorSubject` replays the latest value to new subscribers immediately.
	///
	/// - Returns: A `BehaviorSubject` emitting the current client value and future changes.
	func resolve() -> BehaviorSubject<MobileAuthenticationClient?>

	/// Resets the state of the provider.
	func reset()
}
