//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication
import RxSwift

/// Default implementation of ``ClientProvider`` protocol.
class ClientProviderImpl {

	// MARK: - Properties

	/// The client.
	private var client: MobileAuthenticationClient?

	/// Observable sequence used to emit the client.
	private let clientSubject = BehaviorSubject<MobileAuthenticationClient?>(value: nil)
}

// MARK: - ClientProvider

extension ClientProviderImpl: ClientProvider {
	func save(client: MobileAuthenticationClient) {
		self.client = client
		clientSubject.on(.next(client))
	}

	func get() -> MobileAuthenticationClient? {
		client
	}

	func resolve() -> BehaviorSubject<MobileAuthenticationClient?> {
		clientSubject
	}

	func reset() {
		client = nil
	}
}
