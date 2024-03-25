//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2023. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication

/// Default implementation of ``DevicePasscodeUserVerifier`` protocol.
///
/// With the help of the ``ResponseEmitter`` it will emit a ``VerifyDevicePasscodeResponse``.
class DevicePasscodeUserVerifierImpl {

	// MARK: - Properties

	/// The response emitter.
	private let responseEmitter: ResponseEmitter

	/// The logger.
	private let logger: SDKLogger

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameters:
	///   - responseEmitter: The response emitter.
	///   - logger: The logger.
	init(responseEmitter: ResponseEmitter,
	     logger: SDKLogger) {
		self.responseEmitter = responseEmitter
		self.logger = logger
	}
}

// MARK: - DevicePasscodeUserVerifier

extension DevicePasscodeUserVerifierImpl: DevicePasscodeUserVerifier {
	func verifyDevicePasscode(context: DevicePasscodeUserVerificationContext, handler: DevicePasscodeUserVerificationHandler) {
		logger.log("Please start device passcode user verification.")

		let response = VerifyDevicePasscodeResponse(authenticator: context.authenticator.localizedTitle,
		                                            handler: handler)
		responseEmitter.subject.onNext(response)
	}
}
