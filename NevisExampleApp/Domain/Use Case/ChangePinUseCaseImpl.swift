//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication
import RxSwift

/// Default implementation of ``ChangePinUseCase`` protocol.
class ChangePinUseCaseImpl {

	// MARK: - Properties

	/// The client provider.
	private let clientProvider: ClientProvider

	/// The PIN changer.
	private let pinChanger: PinChanger

	/// The logger.
	private let logger: SDKLogger

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameters:
	///   - clientProvider: The client provider.
	///   - pinChanger: The PIN changer.
	///   - logger: The logger.
	init(clientProvider: ClientProvider,
	     pinChanger: PinChanger,
	     logger: SDKLogger) {
		self.clientProvider = clientProvider
		self.pinChanger = pinChanger
		self.logger = logger
	}
}

// MARK: - ChangePinUseCase

extension ChangePinUseCaseImpl: ChangePinUseCase {
	func execute(username: String) -> Observable<OperationResponse> {
		Observable.create { [weak self] observer in
			guard let self else {
				return Disposables.create()
			}

			let client = clientProvider.get()
			client?.operations.pinChange
				.username(username)
				.pinChanger(pinChanger)
				.onSuccess {
					self.logger.log("PIN change succeeded.", color: .green)
					observer.onNext(CompletedResponse(operation: .pinChange))
					observer.onCompleted()
				}
				.onError {
					self.logger.log("PIN change failed.", color: .red)
					observer.onError(OperationError(operation: .pinChange,
					                                underlyingError: $0))
				}
				.execute()

			return Disposables.create()
		}
	}
}
