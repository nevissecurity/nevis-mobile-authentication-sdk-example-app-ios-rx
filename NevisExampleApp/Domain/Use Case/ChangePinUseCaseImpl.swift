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

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameters:
	///   - clientProvider: The client provider.
	///   - pinChanger: The PIN changer.
	init(clientProvider: ClientProvider,
	     pinChanger: PinChanger) {
		self.clientProvider = clientProvider
		self.pinChanger = pinChanger
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
					logger.sdk("PIN change succeeded.", .green)
					observer.onNext(CompletedResponse(operation: .pinChange))
					observer.onCompleted()
				}
				.onError {
					logger.sdk("PIN change failed.", .red)
					observer.onError(OperationError(operation: .pinChange,
					                                underlyingError: $0))
				}
				.execute()

			return Disposables.create()
		}
	}
}
