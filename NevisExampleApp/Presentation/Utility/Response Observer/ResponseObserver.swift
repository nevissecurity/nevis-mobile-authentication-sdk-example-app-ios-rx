//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import RxSwift

/// Protocol declaration for domain response observing.
protocol ResponseObserver {

	/// Starts observing.
	func start()

	/// Observes for a given response.
	///
	/// - Parameter response: The emitted response.
	/// - Returns: The observable sequence that will emit an `Void` object.
	func observe(response: OperationResponse) -> Observable<()>
}
