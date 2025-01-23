//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication
import RxSwift

/// Default implementation of ``GetDeviceInformationUseCase`` protocol.
class GetDeviceInformationUseCaseImpl {

	// MARK: - Properties

	/// The client provider.
	private let clientProvider: ClientProvider

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameter clientProvider: The client provider.
	init(clientProvider: ClientProvider) {
		self.clientProvider = clientProvider
	}
}

// MARK: - GetDeviceInformationUseCase

extension GetDeviceInformationUseCaseImpl: GetDeviceInformationUseCase {
	func execute() -> Observable<DeviceInformation> {
		Observable.create { [unowned self] observer in
			let client = clientProvider.get()
			let deviceInformation = client?.localData.deviceInformation
			let disposable = Disposables.create()
			guard let deviceInformation else {
				logger.sdk("Get device information failed.", .red)
				observer.onError(BusinessError.deviceInformationNotFound)
				return disposable
			}

			logger.sdk("Get device information succeeded.", .green)
			observer.onNext(deviceInformation)
			observer.onCompleted()
			return disposable
		}
	}
}
