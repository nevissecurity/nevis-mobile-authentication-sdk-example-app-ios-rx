//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication

/// Default implementation of ``PinEnroller`` protocol.
///
/// With the help of the ``ResponseEmitter`` it will emit an ``EnrollPinResponse``.
class PinEnrollerImpl {

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

// MARK: - PinEnroller

extension PinEnrollerImpl: PinEnroller {
	func enrollPin(context: PinEnrollmentContext, handler: PinEnrollmentHandler) {
		if context.lastRecoverableError != nil {
			logger.log("PIN enrollment failed. Please try again.")
		}
		else {
			logger.log("Please start PIN enrollment.")
		}

		let response = EnrollPinResponse(lastRecoverableError: context.lastRecoverableError,
		                                 handler: handler)
		responseEmitter.subject.onNext(response)
	}

	/// You can add custom PIN policy by overriding the `pinPolicy` getter
	/// The default is `PinPolicy(minLength: 6, maxLength: 6)`
	/// func pinPolicy() -> PinPolicy {
	/// 	PinPolicy(minLength: 5, maxLength: 8)
	/// }
}
