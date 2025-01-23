//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication
import RxSwift

/// Use case for initializing the client.
protocol InitClientUseCase {

	/// Initializes the client.
	///
	/// - Parameters:
	///   - configuration: The configuration of the client.
	/// - Returns: The observable sequence that will emit a `Void` object.
	func execute(configuration: Configuration) -> Observable<()>
}
