//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2023. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication

/// Default implementation of `DevicePasscodeUserVerifier` protocol.
/// For more information about device passcode user verification please read the [official documentation](https://docs.nevis.net/mobilesdk/guide/operation/registration#device-passcode-user-verifier).
///
/// With the help of the ``ResponseEmitter`` it will emit a ``VerifyDevicePasscodeResponse``.
class DevicePasscodeUserVerifierImpl {

	// MARK: - Properties

	/// The response emitter.
	private let responseEmitter: ResponseEmitter

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameters:
	///   - responseEmitter: The response emitter.
	init(responseEmitter: ResponseEmitter) {
		self.responseEmitter = responseEmitter
	}
}

// MARK: - DevicePasscodeUserVerifier

extension DevicePasscodeUserVerifierImpl: DevicePasscodeUserVerifier {
	func verifyDevicePasscode(context: DevicePasscodeUserVerificationContext, handler: DevicePasscodeUserVerificationHandler) {
		logger.sdk("Please start device passcode user verification.")

		let response = VerifyDevicePasscodeResponse(authenticator: context.authenticator.localizedTitle,
		                                            handler: handler)
		responseEmitter.subject.onNext(response)
	}
}
