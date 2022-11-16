//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication
import RxSwift

/// Use case for starting an Out-of-Band operation.
protocol OutOfBandOperationUseCase {

	/// Starts an Out-of-Band operation with the given payload.
	///
	/// - Parameter payload: The Out-of-Band payload.
	/// - Returns: The observable sequence that will emit an ``OperationResponse`` object.
	func execute(payload: OutOfBandPayload) -> Observable<OperationResponse>
}
