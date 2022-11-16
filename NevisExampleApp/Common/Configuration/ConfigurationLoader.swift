//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import RxSwift

/// Protocol declaration for loading application configuration.
protocol ConfigurationLoader {

	/// The actual environment.
	var environment: Environment { get }

	/// Loads the application configuration.
	///
	/// - Returns: The observable sequence that will emit an ``AppConfiguration`` object.
	func load() -> Observable<AppConfiguration>
}
