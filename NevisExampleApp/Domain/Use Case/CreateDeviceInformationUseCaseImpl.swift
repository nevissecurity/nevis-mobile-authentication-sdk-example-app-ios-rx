//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication
import UIKit

/// Default implementation of ``CreateDeviceInformationUseCase`` protocol.
class CreateDeviceInformationUseCaseImpl {}

// MARK: - CreateDeviceInformationUseCase

extension CreateDeviceInformationUseCaseImpl: CreateDeviceInformationUseCase {
	func execute() -> DeviceInformation {
		DeviceInformation(name: UIDevice.extendedName)
	}
}
