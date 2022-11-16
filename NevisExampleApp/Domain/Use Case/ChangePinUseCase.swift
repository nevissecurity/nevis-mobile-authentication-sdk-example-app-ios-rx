//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import RxSwift

/// Use case for changing PIN.
protocol ChangePinUseCase {

	/// Changes the PIN.
	///
	/// - Parameter username: The username whose PIN needs to be changed.
	/// - Returns: The observable sequence that will emit an ``OperationResponse`` object.
	func execute(username: String) -> Observable<OperationResponse>
}
