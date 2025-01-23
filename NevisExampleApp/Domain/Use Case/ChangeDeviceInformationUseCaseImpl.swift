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

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameters:
	///   - clientProvider: The client provider.
	init(clientProvider: ClientProvider) {
		self.clientProvider = clientProvider
	}
}

// MARK: - ChangeDeviceInformationUseCase

extension ChangeDeviceInformationUseCaseImpl: ChangeDeviceInformationUseCase {
	func execute(name: String?, fcmRegistrationToken: String?, disablePushNotifications: Bool?) -> Observable<OperationResponse> {
		Observable.create { [weak self] observer in
			let client = self?.clientProvider.get()
			let operation = client?.operations.deviceInformationChange
				.onSuccess {
					logger.sdk("Change device information succeeded.", .green)
					observer.onNext(CompletedResponse(operation: .deviceInformationChange))
					observer.onCompleted()
				}
				.onError {
					logger.sdk("Change device information failed.", .red)
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
