//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import Foundation

extension URLRequest {
	/// Form URL encodes the content of a map and assigns it to the `httpBody` property.
	///
	/// - Parameter parameters: The map that will be the encoded body of the request.
	mutating func encode(parameters: [String: String]) {
		let parameterArray = parameters.map { arg -> String in
			let (key, value) = arg
			return "\(key)=\(value.percentEscaped()))"
		}

		httpBody = parameterArray.joined(separator: "&").data(using: .utf8)
	}
}
