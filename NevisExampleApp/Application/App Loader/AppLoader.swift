//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import UIKit

/// Performs application load related operations.
enum AppLoader {

	/// Loads the application.
	static func load() {
		setupObserving()
		setupNavigation()
	}
}

// MARK: - Private Interface

private extension AppLoader {

	/// Sets up the navigation.
	static func setupNavigation() {
		let appCoordinator = DependencyProvider.shared.container.resolve(AppCoordinator.self)
		appCoordinator?.start()
	}

	/// Starts domain event observing.
	static func setupObserving() {
		let observer = DependencyProvider.shared.container.resolve(ResponseObserver.self)
		observer?.start()
	}
}
