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

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameters:
	///   - clientProvider: The client provider.
	///   - createDeviceInformationUseCase: Use case for creating device information.
	///   - authenticatorSelector: The authenticator selector.
	///   - pinEnroller: The PIN enroller.
	///   - biometricUserVerifier: The biometric user verifier.
	init(clientProvider: ClientProvider,
	     createDeviceInformationUseCase: CreateDeviceInformationUseCase,
	     authenticatorSelector: AuthenticatorSelector,
	     pinEnroller: PinEnroller,
	     biometricUserVerifier: BiometricUserVerifier) {
		self.clientProvider = clientProvider
		self.createDeviceInformationUseCase = createDeviceInformationUseCase
		self.authenticatorSelector = authenticatorSelector
		self.pinEnroller = pinEnroller
		self.biometricUserVerifier = biometricUserVerifier
	}
}

// MARK: - RegistrationUseCase

extension RegistrationUseCaseImpl: RegistrationUseCase {
	func execute(username: String, authorizationProvider: AuthorizationProvider?) -> Observable<OperationResponse> {
		Observable.create { [weak self] observer in
			guard let self = self else {
				return Disposables.create()
			}

			let client = self.clientProvider.get()
			let operation = client?.operations.registration
				.username(username)
				.deviceInformation(self.createDeviceInformationUseCase.execute())
				.authenticatorSelector(self.authenticatorSelector)
				.pinEnroller(self.pinEnroller)
				.biometricUserVerifier(self.biometricUserVerifier)
				.onSuccess {
					observer.onNext(CompletedResponse(operation: .registration))
					observer.onCompleted()
				}
				.onError(observer.onError)

			if let authorizationProvider = authorizationProvider {
				operation?.authorizationProvider(authorizationProvider)
			}

			operation?.execute()
			return Disposables.create()
		}
	}
}
