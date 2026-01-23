//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import UIKit

/// Performs application load related operations.
enum AppLoader {

	/// Loads the application.
	///
	/// - Parameter scene: The `UIWindowScene` to start the coordinator on.
	static func load(using scene: UIWindowScene) {
		setupObserving()
		setupNavigation(using: scene)
	}
}

// MARK: - Private Interface

private extension AppLoader {

	/// Sets up the navigation.
	///
	/// - Parameter scene: The `UIWindowScene` to start the coordinator on.
	static func setupNavigation(using scene: UIWindowScene) {
		let appCoordinator = DependencyProvider.shared.container.resolve(AppCoordinator.self)
		appCoordinator?.start(on: scene)
	}

	/// Starts domain event observing.
	static func setupObserving() {
		let observer = DependencyProvider.shared.container.resolve(ResponseObserver.self)
		observer?.start()
	}
}
