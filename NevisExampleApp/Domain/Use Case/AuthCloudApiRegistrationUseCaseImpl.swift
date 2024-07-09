//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication
import RxSwift

/// Default implementation of ``AuthCloudApiRegistrationUseCase`` protocol.
class AuthCloudApiRegistrationUseCaseImpl {

	// MARK: - Properties

	/// The client provider.
	private let clientProvider: ClientProvider

	/// Use case for creating device information.
	private let createDeviceInformationUseCase: CreateDeviceInformationUseCase

	/// The authenticator selector.
	private let authenticatorSelector: AuthenticatorSelector

	/// The PIN enroller.
	private let pinEnroller: PinEnroller

	/// The Password enroller.
	private let passwordEnroller: PasswordEnroller

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
	///   - createDeviceInformationUseCase: Use case for creating device information.
	///   - authenticatorSelector: The authenticator selector.
	///   - pinEnroller: The PIN enroller.
	///   - passwordEnroller: The Password enroller.
	///   - biometricUserVerifier: The biometric user verifier.
	///   - devicePasscodeUserVerifier: The device passcode user verifier.
	///   - logger: The logger.
	init(clientProvider: ClientProvider,
	     createDeviceInformationUseCase: CreateDeviceInformationUseCase,
	     authenticatorSelector: AuthenticatorSelector,
	     pinEnroller: PinEnroller,
	     passwordEnroller: PasswordEnroller,
	     biometricUserVerifier: BiometricUserVerifier,
	     devicePasscodeUserVerifier: DevicePasscodeUserVerifier,
	     logger: SDKLogger) {
		self.clientProvider = clientProvider
		self.createDeviceInformationUseCase = createDeviceInformationUseCase
		self.authenticatorSelector = authenticatorSelector
		self.pinEnroller = pinEnroller
		self.passwordEnroller = passwordEnroller
		self.biometricUserVerifier = biometricUserVerifier
		self.devicePasscodeUserVerifier = devicePasscodeUserVerifier
		self.logger = logger
	}
}

// MARK: - AuthCloudApiRegistrationUseCase

extension AuthCloudApiRegistrationUseCaseImpl: AuthCloudApiRegistrationUseCase {
	func execute(enrollResponse: String?, appLinkUri: String?) -> Observable<OperationResponse> {
		Observable.create { [weak self] observer in
			guard let self else {
				return Disposables.create()
			}

			let client = clientProvider.get()
			let operation = client?.operations.authCloudApiRegistration
				.deviceInformation(createDeviceInformationUseCase.execute())
				.authenticatorSelector(authenticatorSelector)
				.pinEnroller(pinEnroller)
				.passwordEnroller(passwordEnroller)
				.biometricUserVerifier(biometricUserVerifier)
				.devicePasscodeUserVerifier(devicePasscodeUserVerifier)
				.onSuccess {
					self.logger.log("Auth Cloud Api registration succeeded.", color: .green)
					observer.onNext(CompletedResponse(operation: .registration))
					observer.onCompleted()
				}
				.onError {
					self.logger.log("Auth Cloud Api registration failed.", color: .red)
					observer.onError(OperationError(operation: .registration,
					                                underlyingError: $0))
				}

			// Emtpy string is not allowed!
			if let enrollResponse, !enrollResponse.isEmpty {
				operation?.enrollResponse(enrollResponse)
			}

			// Emtpy string is not allowed!
			if let appLinkUri, !appLinkUri.isEmpty {
				operation?.appLinkUri(appLinkUri)
			}

			operation?.execute()
			return Disposables.create()
		}
	}
}
