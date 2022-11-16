//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import RxSwift

/// Use case for In-Band authentication.
protocol InBandAuthenticationUseCase {

	/// Authenticates the given `username`.
	///
	/// - Parameter username: The username.
	/// - Parameter operation: The ongoing operation.
	/// - Returns: The observable sequence that will emit an ``OperationResponse`` object.
	func execute(username: String, operation: Operation) -> Observable<OperationResponse>
}
