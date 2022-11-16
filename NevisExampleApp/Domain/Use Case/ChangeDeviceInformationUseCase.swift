//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import RxSwift

/// Use case for changing device information.
protocol ChangeDeviceInformationUseCase {

	/// Changes the device information.
	///
	/// - Parameters:
	///   - name: Specifies the new name of the device information.
	///   - fcmRegistrationToken: Specifies the new Firebase Cloud Messaging registration token.
	///   - disablePushNotifications: Disables the push notifications on the server side.
	/// - Returns: The observable sequence that will emit an ``OperationResponse`` object.
	func execute(name: String?, fcmRegistrationToken: String?, disablePushNotifications: Bool?) -> Observable<OperationResponse>
}
