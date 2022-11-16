//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication
import RxSwift

/// Use case for decoding an Out-of-Band payload.
protocol DecodePayloadUseCase {

	/// Decodes an Out-of-Band payload.
	///
	/// - Important: You must provide either the JSON through this method or the Base64 URL encoded representation of the JSON
	/// - Parameters:
	///   - json: Specifies the JSON to be decoded.
	///   - base64UrlEncoded: Specifies the JSON as Base64 URL encoded `String` to be decoded.
	/// - Returns: The observable sequence that will emit an ``OperationResponse`` object.
	func execute(json: String?, base64UrlEncoded: String?) -> Observable<OutOfBandPayload>
}
