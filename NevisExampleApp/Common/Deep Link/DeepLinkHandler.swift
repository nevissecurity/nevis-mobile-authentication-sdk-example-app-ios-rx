//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import Foundation

/// Describes deep link handling related operations.
protocol DeepLinkHandler {

	/// Handles a deep link.
	///
	/// - Parameter deepLink: The deep link that need to be handled.
	func handle(_ deepLink: DeepLink)
}
