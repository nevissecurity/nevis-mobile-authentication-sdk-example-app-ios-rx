//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication
import RxSwift

/// Default implementation of ``InBandAuthenticationUseCase`` protocol.
class InBandAuthenticationUseCaseImpl {

	// MARK: - Properties

	/// The client provider.
	private let clientProvider: ClientProvider

	/// The authenticator selector.
	private let authenticatorSelector: AuthenticatorSelector

	/// The PIN user verifier.
	private let pinUserVerifier: PinUserVerifier

	/// The biometric user verifier.
	private let biometricUserVerifier: BiometricUserVerifier

	/// The logger.
	private let logger: SDKLogger

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameters:
	///   - clientProvider: The client provider.
	///   - authenticatorSelector: The authenticator selector.
	///   - pinUserVerifier: The PIN user verifier.
	///   - biometricUserVerifier: The biometric user verifier.
	///   - logger: The logger.
	init(clientProvider: ClientProvider,
	     authenticatorSelector: AuthenticatorSelector,
	     pinUserVerifier: PinUserVerifier,
	     biometricUserVerifier: BiometricUserVerifier,
	     logger: SDKLogger) {
		self.clientProvider = clientProvider
		self.authenticatorSelector = authenticatorSelector
		self.pinUserVerifier = pinUserVerifier
		self.biometricUserVerifier = biometricUserVerifier
		self.logger = logger
	}
}

// MARK: - InBandAuthenticationUseCase

extension InBandAuthenticationUseCaseImpl: InBandAuthenticationUseCase {
	func execute(username: String, operation: Operation) -> Observable<OperationResponse> {
		Observable.create { [weak self] observer in
			guard let self = self else { return Disposables.create() }

			let client = self.clientProvider.get()
			client?.operations.authentication
				.username(username)
				.authenticatorSelector(self.authenticatorSelector)
				.pinUserVerifier(self.pinUserVerifier)
				.biometricUserVerifier(self.biometricUserVerifier)
				.onSuccess {
					self.logger.log("In-Band authentication succeeded.", color: .green)
					if let cookieAuthorizationProvider = $0 as? CookieAuthorizationProvider {
						self.logger.log("Received cookies: \(cookieAuthorizationProvider.cookies)")
					}
					else if let jwtAuthorizationProvider = $0 as? JwtAuthorizationProvider {
						self.logger.log("Received JWT is \(jwtAuthorizationProvider.jwt)")
					}

					observer.onNext(CompletedResponse(operation: operation,
					                                  authorizationProvider: $0))
					observer.onCompleted()
				}
				.onError {
					self.logger.log("In-Band authentication failed.", color: .red)
					observer.onError(OperationError(operation: .authentication,
					                                underlyingError: $0))
				}
				.execute()

			return Disposables.create()
		}
	}
}
