//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication
import RxSwift

/// Default implementation of ``RegistrationUseCase`` protocol.
class RegistrationUseCaseImpl {

	// MARK: - Properties

	/// The client provider.
	private let clientProvider: ClientProvider

	/// Use case for creating device information.
	private let createDeviceInformationUseCase: CreateDeviceInformationUseCase

	/// The authenticator selector.
	private let authenticatorSelector: AuthenticatorSelector

	/// The PIN enroller.
	private let pinEnroller: PinEnroller

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
	///   - authenticatorSelector: The authenticator selector.
	///   - pinEnroller: The PIN enroller.
	///   - biometricUserVerifier: The biometric user verifier.
	///   - devicePasscodeUserVerifier: The device passcode user verifier.
	init(clientProvider: ClientProvider,
	     createDeviceInformationUseCase: CreateDeviceInformationUseCase,
	     authenticatorSelector: AuthenticatorSelector,
	     pinEnroller: PinEnroller,
	     biometricUserVerifier: BiometricUserVerifier,
	     devicePasscodeUserVerifier: DevicePasscodeUserVerifier) {
		self.clientProvider = clientProvider
		self.createDeviceInformationUseCase = createDeviceInformationUseCase
		self.authenticatorSelector = authenticatorSelector
		self.pinEnroller = pinEnroller
		self.biometricUserVerifier = biometricUserVerifier
		self.devicePasscodeUserVerifier = devicePasscodeUserVerifier
	}
}

// MARK: - RegistrationUseCase

extension RegistrationUseCaseImpl: RegistrationUseCase {
	func execute(username: String, authorizationProvider: AuthorizationProvider?) -> Observable<OperationResponse> {
		Observable.create { [weak self] observer in
			guard let self else {
				return Disposables.create()
			}

			/// Nevis Mobile Authentication SDK supports registering authenticators in multiple servers.
			/// You can specify the base URL of the server where the registration should be made, see ``Registration/serverUrl(_:)``.
			/// If no server base URL is provided, then the base URL defined in ``Configuration/baseUrl`` will be used.
			let client = clientProvider.get()
			let operation = client?.operations.registration
				.username(username)
				.deviceInformation(createDeviceInformationUseCase.execute())
				.authenticatorSelector(authenticatorSelector)
				.pinEnroller(pinEnroller)
				.biometricUserVerifier(biometricUserVerifier)
				.devicePasscodeUserVerifier(devicePasscodeUserVerifier)
				.onSuccess {
					observer.onNext(CompletedResponse(operation: .registration))
					observer.onCompleted()
				}
				.onError(observer.onError)

			if let authorizationProvider {
				operation?.authorizationProvider(authorizationProvider)
			}

			operation?.execute()
			return Disposables.create()
		}
	}
}
