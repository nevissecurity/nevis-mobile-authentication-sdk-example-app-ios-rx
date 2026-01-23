//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2026 Nevis Security AG. All rights reserved.
//

import UIKit

/// Manages the scene lifecycle for the example app.
///
/// Responsible for starting the application coordinator when the scene connects
/// and for routing incoming deep links to the out-of-band operation handler.
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	/// Called when the scene is being created and about to connect to a session.
	///
	/// The method resolves the main `UIWindowScene` and starts the shared `AppCoordinator` on that scene.
	/// If the window scene cannot be obtained, a log entry is recorded and the method returns early.
	///
	/// - Parameters:
	///   - scene: The scene being connected.
	///   - session: The session associated with the connecting scene.
	///   - connectionOptions: Additional options used to configure the scene.
	// swiftformat:disable:next unusedArguments
	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let windowScene = scene as? UIWindowScene else {
			return logger.app("Failed to get the UIWindow scene.", .red, .error)
		}

		AppLoader.load(using: windowScene)

		if let urlContext = connectionOptions.urlContexts.first {
			logger.app("App (just launched) opened by custom URL scheme.")
			handle(url: urlContext.url)
		}
	}
}

// MARK: - Custom URL Scheme

extension SceneDelegate {
	/// Called when the app is asked to open URLs (deep links).
	///
	/// The method extracts the first URL context and forwards the URL to `handle(url:)`.
	///
	/// - Parameters:
	///   - scene: The scene that UIKit asks to open the URL.
	///   - URLContexts: A set of `UIOpenURLContext` objects containing the URLs to open.
	// swiftformat:disable:next unusedArguments
	func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
		if let urlContext = URLContexts.first {
			logger.app("App (foreground) opened by custom URL scheme.")
			handle(url: urlContext.url)
		}
	}

	/// Handles an incoming URL by attempting to parse it as a `DeepLink` and forwarding its payload.
	///
	/// - Parameter url: The incoming `URL` to handle.
	private func handle(url: URL) {
		guard let deepLink = DeepLink.build(with: url) else {
			return logger.app("Failed to parse deep link. URL is not a recognized DeepLink: %@", .red, .error, url.absoluteString)
		}

		guard let deepLinkHandler = DependencyProvider.shared.container.resolve(DeepLinkHandler.self) else {
			return logger.app("Failed to resolve DeepLinkHandler from dependency container. Deep link ignored. URL: %@", .red, .error, url.absoluteString)
		}

		deepLinkHandler.handle(deepLink)
	}
}
