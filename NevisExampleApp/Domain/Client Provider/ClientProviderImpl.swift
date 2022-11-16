//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication

/// Default implementation of ``ClientProvider`` protocol.
class ClientProviderImpl {

	// MARK: - Properties

	/// The client.
	var client: MobileAuthenticationClient?
}

// MARK: - ClientProvider

extension ClientProviderImpl: ClientProvider {
	func save(client: MobileAuthenticationClient) {
		self.client = client
	}

	func get() -> MobileAuthenticationClient? {
		client
	}

	func reset() {
		client = nil
	}
}
