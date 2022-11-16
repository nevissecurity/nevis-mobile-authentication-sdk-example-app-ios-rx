//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import UIKit

///  The application's delegate.
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

	/// Tells the delegate that the launch process is almost done and the app is almost ready to run.
	/// Use this method (and the corresponding application(_:willFinishLaunchingWithOptions:) method) to complete your app’s initialization and make any final tweaks.
	///
	/// - Parameters:
	///   - application: The singleton app object.
	///   - launchOptions: A dictionary indicating the reason the app was launched (if any). The contents of this dictionary may be empty in situations where the user launched the app directly.
	/// - Returns: Returns *false* if the app cannot handle the URL resource or continue a user activity, otherwise return *true*. The return value is ignored if the app is launched as a result of a remote notification.
	func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		AppLoader.load()
		return true
	}
}

// MARK: - URL Schemes

extension AppDelegate {

	/// Asks the delegate to open a resource specified by a URL, and provides a dictionary of launch options.
	///
	/// - Parameters:
	///   - app: The singleton app object.
	///   - url: The URL resource to open. This resource can be a network resource or a file. For information about the Apple-registered URL schemes, see Apple URL Scheme Reference.
	///   - options: A dictionary of URL handling options. For information about the possible keys in this dictionary and how to handle them, see UIApplicationOpenURLOptionsKey. By default, the value of this parameter is an empty dictionary.
	/// - Returns: *true* if the delegate successfully handled the request or *false* if the attempt to open the URL resource failed.
	func application(_: UIApplication, open url: URL, options _: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
		handleUrl(url)
	}

	/// Handles the given url.
	///
	/// - Parameter url: The url to handle.
	/// - Returns: Returns *true* if the url can be handled, *false* otherwise.
	private func handleUrl(_ url: URL) -> Bool {
		guard let deepLink = DeepLink.build(with: url) else {
			return false
		}

		let deepLinkHandler = DependencyProvider.shared.container.resolve(DeepLinkHandler.self)
		deepLinkHandler?.handle(deepLink)
		return true
	}
}
