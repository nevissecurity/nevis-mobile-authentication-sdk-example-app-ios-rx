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

	/// The Password user verifier.
	private let passwordUserVerifier: PasswordUserVerifier

	/// The biometric user verifier.
	private let biometricUserVerifier: BiometricUserVerifier

	/// The device passcode user verifier.
	private let devicePasscodeUserVerifier: DevicePasscodeUserVerifier

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameters:
	///   - clientProvider: The client provider.
	///   - authenticatorSelector: The authenticator selector.
	///   - pinUserVerifier: The PIN user verifier.
	///   - passwordUserVerifier: The Password user verifier.
	///   - biometricUserVerifier: The biometric user verifier.
	///   - devicePasscodeUserVerifier: The device passcode user verifier.
	init(clientProvider: ClientProvider,
	     authenticatorSelector: AuthenticatorSelector,
	     pinUserVerifier: PinUserVerifier,
	     passwordUserVerifier: PasswordUserVerifier,
	     biometricUserVerifier: BiometricUserVerifier,
	     devicePasscodeUserVerifier: DevicePasscodeUserVerifier) {
		self.clientProvider = clientProvider
		self.authenticatorSelector = authenticatorSelector
		self.pinUserVerifier = pinUserVerifier
		self.passwordUserVerifier = passwordUserVerifier
		self.biometricUserVerifier = biometricUserVerifier
		self.devicePasscodeUserVerifier = devicePasscodeUserVerifier
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
				.passwordUserVerifier(passwordUserVerifier)
				.biometricUserVerifier(biometricUserVerifier)
				.devicePasscodeUserVerifier(devicePasscodeUserVerifier)
				.onSuccess {
					logger.sdk("In-Band authentication succeeded.", .green)
					self.printAuthorizationInfo($0)

					observer.onNext(CompletedResponse(operation: operation,
					                                  authorizationProvider: $0))
					observer.onCompleted()
				}
				.onError { error in
					logger.sdk("In-Band authentication failed.", .red)
					switch error {
					case let .FidoError(_, _, sessionProvider),
					     let .NetworkError(_, sessionProvider):
						self.printSessionInfo(sessionProvider)
					case .NoDeviceLockError:
						fallthrough
					case .Unknown:
						fallthrough
					@unknown default:
						logger.sdk("In-band authentication failed because of an unknown error.", .red)
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
	/// Prints authorization information to the console.
	///
	/// - Parameter authorizationProvider: The ``AuthorizationProvider`` holding the authorization information.
	func printAuthorizationInfo(_ authorizationProvider: AuthorizationProvider?) {
		if let cookieAuthorizationProvider = authorizationProvider as? CookieAuthorizationProvider {
			logger.sdk("Received cookies: %@", .black, .debug, cookieAuthorizationProvider.cookies)
		}
		else if let jwtAuthorizationProvider = authorizationProvider as? JwtAuthorizationProvider {
			logger.sdk("Received JWT is %@", .black, .debug, jwtAuthorizationProvider.jwt)
		}
	}

	/// Prints session information to the console.
	///
	/// - Parameter sessionProvider: The ``SessionProvider`` holding the session information.
	func printSessionInfo(_ sessionProvider: SessionProvider?) {
		if let cookieSessionProvider = sessionProvider as? CookieSessionProvider {
			logger.sdk("Received cookies: %@", .black, .debug, cookieSessionProvider.cookies)
		}
		else if let jwtSessionProvider = sessionProvider as? JwtSessionProvider {
			logger.sdk("Received JWT is %@", .black, .debug, jwtSessionProvider.jwt)
		}
	}
}
