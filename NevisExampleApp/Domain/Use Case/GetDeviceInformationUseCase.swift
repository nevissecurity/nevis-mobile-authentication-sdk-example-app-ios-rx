//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication
import RxSwift

/// Use case for retrieving the device information.
protocol GetDeviceInformationUseCase {

	/// Retrieves the device information.
	///
	/// - Returns: The observable sequence that will emit a `DeviceInformation` object.
	func execute() -> Observable<DeviceInformation>
}
