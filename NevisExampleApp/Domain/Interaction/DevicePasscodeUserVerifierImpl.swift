//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2023. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication

/// Default implementation of ``DevicePasscodeUserVerifier`` protocol.
class DevicePasscodeUserVerifierImpl {

	// MARK: - Properties

	/// The logger.
	private let logger: SDKLogger

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameter logger: The logger.
	init(logger: SDKLogger) {
		self.logger = logger
	}
}

// MARK: - DevicePasscodeUserVerifier

extension DevicePasscodeUserVerifierImpl: DevicePasscodeUserVerifier {
	func verifyDevicePasscode(context _: DevicePasscodeUserVerificationContext, handler: DevicePasscodeUserVerificationHandler) {
		logger.log("Please start device passcode user verification.")
		logger.log("Performing automatic user verification.")
		handler.verify()
	}
}
