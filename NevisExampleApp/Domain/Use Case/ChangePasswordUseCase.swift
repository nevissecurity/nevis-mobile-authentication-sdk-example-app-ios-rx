//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2024 Nevis Security AG. All rights reserved.
//

import RxSwift

/// Use case for changing Password.
protocol ChangePasswordUseCase {

	/// Changes the Password.
	///
	/// - Parameter username: The username whose Password needs to be changed.
	/// - Returns: The observable sequence that will emit an ``OperationResponse`` object.
	func execute(username: String) -> Observable<OperationResponse>
}
