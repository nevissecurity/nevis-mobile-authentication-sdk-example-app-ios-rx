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

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameter clientProvider: The client provider.
	init(clientProvider: ClientProvider) {
		self.clientProvider = clientProvider
	}
}

// MARK: - DecodePayloadUseCase

extension DecodePayloadUseCaseImpl: DecodePayloadUseCase {
	func execute(json: String?, base64UrlEncoded: String?) -> Observable<OutOfBandPayload> {
		Observable.create { [weak self] observer in
			let client = self?.clientProvider.get()
			let operation = client?.operations.outOfBandPayloadDecode
				.onSuccess {
					logger.sdk("Decode payload succeeded.", .green)
					observer.onNext($0)
					observer.onCompleted()
				}
				.onError {
					logger.sdk("Decode payload failed.", .red)
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
