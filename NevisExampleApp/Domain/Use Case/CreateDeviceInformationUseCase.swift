//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication

/// Use case for creating device information.
protocol CreateDeviceInformationUseCase {

	/// Creates device information.
	///
	/// - Returns: The new device information.
	func execute() -> DeviceInformation
}
