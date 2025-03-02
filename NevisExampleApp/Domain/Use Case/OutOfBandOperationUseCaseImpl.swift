//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication
import RxSwift

/// Default implementation of ``OutOfBandOperationUseCase`` protocol.
class OutOfBandOperationUseCaseImpl {

	// MARK: - Properties

	/// The client provider.
	private let clientProvider: ClientProvider

	/// Use case for creating device information.
	private let createDeviceInformationUseCase: CreateDeviceInformationUseCase

	/// The account selector.
	private let accountSelector: AccountSelector

	/// The authenticator selector used during registration.
	private let registrationAuthenticatorSelector: AuthenticatorSelector

	/// The authenticator selector used during authentication.
	private let authenticationAuthenticatorSelector: AuthenticatorSelector

	/// The PIN enroller.
	private let pinEnroller: PinEnroller

	/// The PIN user verifier.
	private let pinUserVerifier: PinUserVerifier

	/// The Password enroller.
	private let passwordEnroller: PasswordEnroller

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
	///   - createDeviceInformationUseCase: Use case for creating device information.
	///   - accountSelector: The account selector.
	///   - registrationAuthenticatorSelector: The authenticator selector used during registration.
	///   - authenticationAuthenticatorSelector: The authenticator selector used during authentication.
	///   - pinEnroller: The PIN enroller.
	///   - pinUserVerifier: The PIN user verifier.
	///   - passwordEnroller: The Password enroller.
	///   - passwordUserVerifier: The Password user verifier.
	///   - biometricUserVerifier: The biometric user verifier.
	///   - devicePasscodeUserVerifier: The device passcode user verifier.
	init(clientProvider: ClientProvider,
	     createDeviceInformationUseCase: CreateDeviceInformationUseCase,
	     accountSelector: AccountSelector,
	     registrationAuthenticatorSelector: AuthenticatorSelector,
	     authenticationAuthenticatorSelector: AuthenticatorSelector,
	     pinEnroller: PinEnroller,
	     pinUserVerifier: PinUserVerifier,
	     passwordEnroller: PasswordEnroller,
	     passwordUserVerifier: PasswordUserVerifier,
	     biometricUserVerifier: BiometricUserVerifier,
	     devicePasscodeUserVerifier: DevicePasscodeUserVerifier) {
		self.clientProvider = clientProvider
		self.createDeviceInformationUseCase = createDeviceInformationUseCase
		self.accountSelector = accountSelector
		self.registrationAuthenticatorSelector = registrationAuthenticatorSelector
		self.authenticationAuthenticatorSelector = authenticationAuthenticatorSelector
		self.pinEnroller = pinEnroller
		self.pinUserVerifier = pinUserVerifier
		self.passwordEnroller = passwordEnroller
		self.passwordUserVerifier = passwordUserVerifier
		self.biometricUserVerifier = biometricUserVerifier
		self.devicePasscodeUserVerifier = devicePasscodeUserVerifier
	}
}

// MARK: - OutOfBandOperationUseCase

extension OutOfBandOperationUseCaseImpl: OutOfBandOperationUseCase {
	func execute(payload: OutOfBandPayload) -> Observable<OperationResponse> {
		Observable.create { [weak self] observer in
			guard let self else {
				return Disposables.create()
			}

			let client = clientProvider.get()
			client?.operations.outOfBandOperation
				.payload(payload)
				.onRegistration {
					self.register(using: $0, observer: observer)
				}
				.onAuthentication {
					self.authenticate(using: $0, observer: observer)
				}
				.onError {
					logger.sdk("Out-of-Band operation failed.", .red)
					observer.onError(OperationError(operation: .outOfBand,
					                                underlyingError: $0))
				}
				.execute()

			return Disposables.create()
		}
	}
}

// MARK: - Private Interface

private extension OutOfBandOperationUseCaseImpl {

	/// Starts an Out-of-Band registration operation.
	///
	/// - Parameters:
	///   - registration: An ``OutOfBandRegistration`` object received from the SDK.
	///   - observer: Observable sequence used to emit the result of the operation.
	func register(using registration: OutOfBandRegistration, observer: AnyObserver<OperationResponse>) {
		registration
			.deviceInformation(createDeviceInformationUseCase.execute())
			.authenticatorSelector(registrationAuthenticatorSelector)
			.pinEnroller(pinEnroller)
			.passwordEnroller(passwordEnroller)
			.biometricUserVerifier(biometricUserVerifier)
			.devicePasscodeUserVerifier(devicePasscodeUserVerifier)
			.onSuccess {
				logger.sdk("Out-of-Band registration succeeded.", .green)
				observer.onNext(CompletedResponse(operation: .registration))
				observer.onCompleted()
			}
			.onError {
				logger.sdk("Out-of-Band registration failed.", .red)
				observer.onError(OperationError(operation: .registration,
				                                underlyingError: $0))
			}
			.execute()
	}

	/// Starts an Out-of-Band authentication operation.
	///
	/// - Parameters:
	///   - registration: An ``OutOfBandAuthentication`` object received from the SDK.
	///   - observer: Observable sequence used to emit the result of the operation.
	func authenticate(using authentication: OutOfBandAuthentication, observer: AnyObserver<OperationResponse>) {
		authentication
			.accountSelector(accountSelector)
			.authenticatorSelector(authenticationAuthenticatorSelector)
			.pinUserVerifier(pinUserVerifier)
			.passwordUserVerifier(passwordUserVerifier)
			.biometricUserVerifier(biometricUserVerifier)
			.devicePasscodeUserVerifier(devicePasscodeUserVerifier)
			.onSuccess {
				logger.sdk("Out-of-Band authentication succeeded.", .green)
				observer.onNext(CompletedResponse(operation: .authentication,
				                                  authorizationProvider: $0))
				observer.onCompleted()
			}
			.onError {
				logger.sdk("Out-of-Band authentication failed.", .red)
				observer.onError(OperationError(operation: .authentication,
				                                underlyingError: $0))
			}
			.execute()
	}
}
