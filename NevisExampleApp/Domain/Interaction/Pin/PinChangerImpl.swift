//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication

/// Default implementation of `PinChanger` protocol.
/// For more information about PIN change please read the [official documentation](https://docs.nevis.net/mobilesdk/guide/operation/other-operations#change-pin).
///
/// With the help of the ``ResponseEmitter`` it will emit a ``ChangePinResponse``.
class PinChangerImpl {

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

// MARK: - PinChanger

extension PinChangerImpl: PinChanger {
	func changePin(context: PinChangeContext, handler: PinChangeHandler) {
		if context.lastRecoverableError != nil {
			logger.sdk("PIN change failed. Please try again.", .red)
		}
		else {
			logger.sdk("Please start PIN change.")
		}

		let response = ChangePinResponse(protectionStatus: context.authenticatorProtectionStatus,
		                                 lastRecoverableError: context.lastRecoverableError,
		                                 handler: handler)
		responseEmitter.subject.onNext(response)
	}

	/// You can add custom PIN policy by overriding the `pinPolicy` getter.
	/// The default minimum and maximum PIN length is 6 without any furhter validation during PIN enrollment or change.
//	func pinPolicy() -> PinPolicy {
//		// custom PinPolicy implementation
//	}
}
