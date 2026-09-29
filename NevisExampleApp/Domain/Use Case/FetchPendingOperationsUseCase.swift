//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication
import RxSwift

/// Use case for fetch pending operations.
protocol FetchPendingOperationsUseCase {

	/// Fetches pending operations.
	///
	/// - Returns: The observable sequence that will emit a ``PendingOutOfBandOperationsResult`` object.
	func execute() -> Observable<PendingOutOfBandOperationsResult>
}
