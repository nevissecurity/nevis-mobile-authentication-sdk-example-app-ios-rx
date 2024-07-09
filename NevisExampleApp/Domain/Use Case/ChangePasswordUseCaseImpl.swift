//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2024 Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication
import RxSwift

/// Default implementation of ``ChangePasswordUseCase`` protocol.
class ChangePasswordUseCaseImpl {

	// MARK: - Properties

	/// The client provider.
	private let clientProvider: ClientProvider

	/// The Password changer.
	private let passwordChanger: PasswordChanger

	/// The logger.
	private let logger: SDKLogger

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameters:
	///   - clientProvider: The client provider.
	///   - passwordChanger: The Password changer.
	///   - logger: The logger.
	init(clientProvider: ClientProvider,
	     passwordChanger: PasswordChanger,
	     logger: SDKLogger) {
		self.clientProvider = clientProvider
		self.passwordChanger = passwordChanger
		self.logger = logger
	}
}

// MARK: - ChangePasswordUseCase

extension ChangePasswordUseCaseImpl: ChangePasswordUseCase {
	func execute(username: String) -> Observable<OperationResponse> {
		Observable.create { [weak self] observer in
			guard let self else {
				return Disposables.create()
			}

			let client = clientProvider.get()
			client?.operations.passwordChange
				.username(username)
				.passwordChanger(passwordChanger)
				.onSuccess {
					self.logger.log("Password change succeeded.", color: .green)
					observer.onNext(CompletedResponse(operation: .passwordChange))
					observer.onCompleted()
				}
				.onError {
					self.logger.log("Password change failed.", color: .red)
					observer.onError(OperationError(operation: .passwordChange,
					                                underlyingError: $0))
				}
				.execute()

			return Disposables.create()
		}
	}
}
