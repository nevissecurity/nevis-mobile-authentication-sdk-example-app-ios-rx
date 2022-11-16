//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import Foundation
import NevisMobileAuthentication

/// Object representation the content of a deep link.
enum DeepLink {

	/// The available parameters.
	private enum Parameter: String {
		/// The dispatch token response parameter.
		case dispatchTokenResponse
	}

	/// Represents out-of-band payload deeplink.
	case oobOperation(String)

	/// Builds a ``DeepLink`` object by processing an url.
	///
	/// - Parameter url: The source of the deep link.
	/// - Returns: The constructed deep link object or `nil` in case of any error.
	static func build(with url: URL) -> DeepLink? {
		guard let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: true)?.queryItems else {
			return nil
		}

		guard let contents = queryItems.first(where: { $0.name == Parameter.dispatchTokenResponse.rawValue })?.value else {
			return nil
		}

		return .oobOperation(contents)
	}
}
