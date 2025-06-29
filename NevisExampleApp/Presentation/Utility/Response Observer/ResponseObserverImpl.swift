//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import RxSwift

/// Default implementation of ``ResponseObserver`` protocol.
class ResponseObserverImpl {

	// MARK: - Properties

	/// The response emitter.
	private let responseEmitter: ResponseEmitter

	/// The application coordinator.
	private let appCoordinator: AppCoordinator

	/// Thread safe bag that disposes added disposables on `deinit`.
	private let disposeBag = DisposeBag()

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameters:
	///   - responseEmitter: The response emitter.
	///   - appCoordinator: The application coordinator.
	init(responseEmitter: ResponseEmitter,
	     appCoordinator: AppCoordinator) {
		self.responseEmitter = responseEmitter
		self.appCoordinator = appCoordinator
	}
}

// MARK: - ResponseObserver

extension ResponseObserverImpl: ResponseObserver {
	func start() {
		responseEmitter.subject
			.asObservable()
			.observe(on: MainScheduler.instance)
			.subscribe(onNext: handle(response:))
			.disposed(by: disposeBag)
	}

	func observe(response: OperationResponse) -> Observable<()> {
		Observable.create {
			self.handle(response: response)
			$0.onCompleted()
			return Disposables.create()
		}
	}
}

private extension ResponseObserverImpl {

	/// Handles the operation response.
	///
	/// - Parameter response: The operation response.
	func handle(response: OperationResponse) {
		if let response = response as? SelectAuthenticatorResponse {
			let parameter: SelectAuthenticatorParameter = .select(authenticatorItems: response.authenticatorItems,
			                                                      handler: response.handler)
			appCoordinator.navigateToAuthenticatorSelection(with: parameter)
		}
		else if let response = response as? SelectAccountResponse {
			let parameter: SelectAccountParameter = .select(accounts: response.accounts,
			                                                operation: .unknown,
			                                                handler: response.handler,
			                                                message: response.transactionConfirmationData)
			appCoordinator.navigateToAccountSelection(with: parameter)
		}
		else if let response = response as? EnrollPinResponse {
			let parameter: PinParameter = .enrollment(lastRecoverableError: response.lastRecoverableError,
			                                          handler: response.handler)
			appCoordinator.navigateToCredential(with: parameter)
		}
		else if let response = response as? EnrollPasswordResponse {
			let parameter: PasswordParameter = .enrollment(lastRecoverableError: response.lastRecoverableError,
			                                               handler: response.handler)
			appCoordinator.navigateToCredential(with: parameter)
		}
		else if let response = response as? VerifyPinResponse {
			let parameter: PinParameter = .verification(protectionStatus: response.protectionStatus,
			                                            handler: response.handler)
			appCoordinator.navigateToCredential(with: parameter)
		}
		else if let response = response as? VerifyPasswordResponse {
			let parameter: PasswordParameter = .verification(protectionStatus: response.protectionStatus,
			                                                 handler: response.handler)
			appCoordinator.navigateToCredential(with: parameter)
		}
		else if let response = response as? VerifyBiometricResponse {
			let parameter: ConfirmationParameter = .confirmBiometric(authenticator: response.authenticator,
			                                                         handler: response.handler)
			appCoordinator.navigateToConfirmation(with: parameter)
		}
		else if let response = response as? VerifyDevicePasscodeResponse {
			let parameter: ConfirmationParameter = .confirmDevicePasscode(authenticator: response.authenticator,
			                                                              handler: response.handler)
			appCoordinator.navigateToConfirmation(with: parameter)
		}
		else if let response = response as? ConfirmTransactionResponse {
			let parameter: TransactionConfirmationParameter = .confirm(message: response.message,
			                                                           account: response.account,
			                                                           handler: response.handler)
			appCoordinator.navigateToTransactionConfirmation(with: parameter)
		}
		else if let response = response as? ChangePinResponse {
			let parameter: PinParameter = .credentialChange(protectionStatus: response.protectionStatus,
			                                                lastRecoverableError: response.lastRecoverableError,
			                                                handler: response.handler)
			appCoordinator.navigateToCredential(with: parameter)
		}
		else if let response = response as? ChangePasswordResponse {
			let parameter: PasswordParameter = .credentialChange(protectionStatus: response.protectionStatus,
			                                                     lastRecoverableError: response.lastRecoverableError,
			                                                     handler: response.handler)
			appCoordinator.navigateToCredential(with: parameter)
		}
		else if let response = response as? CompletedResponse {
			appCoordinator.navigateToResult(with: .success(operation: response.operation))
		}
	}
}
