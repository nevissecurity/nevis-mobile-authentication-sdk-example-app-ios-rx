//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication
import RxSwift

/// Default implementation of ``ChangeDeviceInformationUseCase`` protocol.
class ChangeDeviceInformationUseCaseImpl {

	// MARK: - Properties

	/// The client provider.
	private let clientProvider: ClientProvider

	/// The logger.
	private let logger: SDKLogger

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameters:
	///   - clientProvider: The client provider.
	///   - logger: The logger.
	init(clientProvider: ClientProvider,
	     logger: SDKLogger) {
		self.clientProvider = clientProvider
		self.logger = logger
	}
}

// MARK: - ChangeDeviceInformationUseCase

extension ChangeDeviceInformationUseCaseImpl: ChangeDeviceInformationUseCase {
	func execute(name: String?, fcmRegistrationToken: String?, disablePushNotifications: Bool?) -> Observable<OperationResponse> {
		Observable.create { [weak self] observer in
			let client = self?.clientProvider.get()
			let operation = client?.operations.deviceInformationChange
				.onSuccess {
					self?.logger.log("Change device information succeeded.", color: .green)
					observer.onNext(CompletedResponse(operation: .deviceInformationChange))
					observer.onCompleted()
				}
				.onError {
					self?.logger.log("Change device information failed.", color: .red)
					observer.onError(OperationError(operation: .deviceInformationChange,
					                                underlyingError: $0))
				}

			if let name {
				operation?.name(name)
			}

			if let fcmRegistrationToken {
				operation?.fcmRegistrationToken(fcmRegistrationToken)
			}

			if let disablePushNotifications, disablePushNotifications {
				operation?.disablePushNotifications()
			}

			operation?.execute()
			return Disposables.create()
		}
	}
}
