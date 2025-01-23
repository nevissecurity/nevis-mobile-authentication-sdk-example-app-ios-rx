//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import RxCocoa
import RxSwift

/// View model of Qr Scanner view.
final class QrScannerViewModel {

	// MARK: - Properties

	/// Use case for decoding an Out-of-Band payload.
	private let decodePayloadUseCase: DecodePayloadUseCase

	/// Use case for starting an Out-of-Band operation.
	private let outOfBandOperationUseCase: OutOfBandOperationUseCase

	/// The response observer.
	private let responseObserver: ResponseObserver

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameters:
	///   - decodePayloadUseCase: Use case for decoding an Out-of-Band payload.
	///   - outOfBandOperationUseCase: Use case for starting an Out-of-Band operation.
	///   - responseObserver: The response observer.
	init(decodePayloadUseCase: DecodePayloadUseCase,
	     outOfBandOperationUseCase: OutOfBandOperationUseCase,
	     responseObserver: ResponseObserver) {
		self.decodePayloadUseCase = decodePayloadUseCase
		self.outOfBandOperationUseCase = outOfBandOperationUseCase
		self.responseObserver = responseObserver
	}

	deinit {
		logger.deinit("QrScannerViewModel")
	}
}

// MARK: - ScreenViewModel

extension QrScannerViewModel: ScreenViewModel {

	/// The input of the view model.
	struct Input {
		/// Observable sequence used for listening to the content of the Qr Code.
		let qrContent: Driver<String>
	}

	/// The output of the view model.
	struct Output {
		/// Observable sequence used for listening to Qr Code read event.
		let qrCodeRead: Driver<()>
		/// Observable sequence used for listening to error events.
		let error: Driver<Error>
	}

	/// Performs pure transformation of a user `Input` to the `Output`.
	///
	/// - Parameter input: The input need to be transformed.
	/// - Returns: The transformed output.
	func transform(input: Input) -> Output {
		let errorTracker = ErrorTracker()

		let readQrCode = input.qrContent
			.asObservable()
			.flatMap { self.decodePayloadUseCase.execute(json: nil, base64UrlEncoded: $0) }
			.flatMap(outOfBandOperationUseCase.execute(payload:))
			.flatMap(responseObserver.observe(response:))
			.trackError(errorTracker)
			.asDriverOnErrorJustComplete()

		let error = errorTracker.asDriver()
		return Output(qrCodeRead: readQrCode,
		              error: error)
	}
}
