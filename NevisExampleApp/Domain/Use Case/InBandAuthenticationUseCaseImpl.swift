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

	/// The device passcode user verifier.
	private let devicePasscodeUserVerifier: DevicePasscodeUserVerifier

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
	///   - devicePasscodeUserVerifier: The device passcode user verifier.
	///   - logger: The logger.
	init(clientProvider: ClientProvider,
	     authenticatorSelector: AuthenticatorSelector,
	     pinUserVerifier: PinUserVerifier,
	     biometricUserVerifier: BiometricUserVerifier,
	     devicePasscodeUserVerifier: DevicePasscodeUserVerifier,
	     logger: SDKLogger) {
		self.clientProvider = clientProvider
		self.authenticatorSelector = authenticatorSelector
		self.pinUserVerifier = pinUserVerifier
		self.biometricUserVerifier = biometricUserVerifier
		self.devicePasscodeUserVerifier = devicePasscodeUserVerifier
		self.logger = logger
	}
}

// MARK: - InBandAuthenticationUseCase

extension InBandAuthenticationUseCaseImpl: InBandAuthenticationUseCase {
	func execute(username: String, operation: Operation) -> Observable<OperationResponse> {
		Observable.create { [weak self] observer in
			guard let self else { return Disposables.create() }

			let client = clientProvider.get()
			client?.operations.authentication
				.username(username)
				.authenticatorSelector(authenticatorSelector)
				.pinUserVerifier(pinUserVerifier)
				.biometricUserVerifier(biometricUserVerifier)
				.devicePasscodeUserVerifier(devicePasscodeUserVerifier)
				.onSuccess {
					self.logger.log("In-Band authentication succeeded.", color: .green)
					self.printAuthorizationInfo($0)

					observer.onNext(CompletedResponse(operation: operation,
					                                  authorizationProvider: $0))
					observer.onCompleted()
				}
				.onError { error in
					self.logger.log("In-Band authentication failed.", color: .red)
					switch error {
					case let .FidoError(_, _, sessionProvider),
					     let .NetworkError(_, sessionProvider):
						self.printSessionInfo(sessionProvider)
					case .Unknown:
						fallthrough
					@unknown default:
						self.logger.log("In-band authentication failed because of an unknown error.", color: .red)
					}

					observer.onError(OperationError(operation: .authentication,
					                                underlyingError: error))
				}
				.execute()

			return Disposables.create()
		}
	}
}

// MARK: - Private Interface

private extension InBandAuthenticationUseCaseImpl {
	func printAuthorizationInfo(_ authorizationProvider: AuthorizationProvider?) {
		if let cookieAuthorizationProvider = authorizationProvider as? CookieAuthorizationProvider {
			logger.log("Received cookies: \(cookieAuthorizationProvider.cookies)")
		}
		else if let jwtAuthorizationProvider = authorizationProvider as? JwtAuthorizationProvider {
			logger.log("Received JWT is \(jwtAuthorizationProvider.jwt)")
		}
	}

	func printSessionInfo(_ sessionProvider: SessionProvider?) {
		if let cookieSessionProvider = sessionProvider as? CookieSessionProvider {
			logger.log("Received cookies: \(cookieSessionProvider.cookies)")
		}
		else if let jwtSessionProvider = sessionProvider as? JwtSessionProvider {
			logger.log("Received JWT is \(jwtSessionProvider.jwt)")
		}
	}
}
