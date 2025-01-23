//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication

/// Default implementation of `PinEnroller` protocol.
/// For more information about PIN enrollment please read the [official documentation](https://docs.nevis.net/mobilesdk/guide/operation/registration#pin-enroller).
///
/// With the help of the ``ResponseEmitter`` it will emit an ``EnrollPinResponse``.
class PinEnrollerImpl {

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

// MARK: - PinEnroller

extension PinEnrollerImpl: PinEnroller {
	func enrollPin(context: PinEnrollmentContext, handler: PinEnrollmentHandler) {
		if context.lastRecoverableError != nil {
			logger.sdk("PIN enrollment failed. Please try again.", .red)
		}
		else {
			logger.sdk("Please start PIN enrollment.")
		}

		let response = EnrollPinResponse(lastRecoverableError: context.lastRecoverableError,
		                                 handler: handler)
		responseEmitter.subject.onNext(response)
	}

	/// You can add custom PIN policy by overriding the `pinPolicy` getter.
	/// The default minimum and maximum PIN length is 6 without any furhter validation during PIN enrollment or change.
//	func pinPolicy() -> PinPolicy {
//		// custom PinPolicy implementation
//	}
}
