//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication
import RxSwift

/// Default implementation of ``DecodePayloadUseCase`` protocol.
class DecodePayloadUseCaseImpl {

	// MARK: - Properties

	/// The client provider.
	private let clientProvider: ClientProvider

	/// The logger.
	private let logger: SDKLogger

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameter clientProvider: The client provider.
	init(clientProvider: ClientProvider,
	     logger: SDKLogger) {
		self.clientProvider = clientProvider
		self.logger = logger
	}
}

// MARK: - DecodePayloadUseCase

extension DecodePayloadUseCaseImpl: DecodePayloadUseCase {
	func execute(json: String?, base64UrlEncoded: String?) -> Observable<OutOfBandPayload> {
		Observable.create { [weak self] observer in
			let client = self?.clientProvider.get()
			let operation = client?.operations.outOfBandPayloadDecode
				.onSuccess {
					self?.logger.log("Decode payload succeeded.", color: .green)
					observer.onNext($0)
					observer.onCompleted()
				}
				.onError {
					self?.logger.log("Decode payload failed.", color: .red)
					observer.onError(OperationError(operation: .payloadDecode,
					                                underlyingError: $0))
				}

			if let json {
				operation?.json(json)
			}

			if let base64UrlEncoded {
				operation?.base64UrlEncoded(base64UrlEncoded)
			}

			operation?.execute()
			return Disposables.create()
		}
	}
}
