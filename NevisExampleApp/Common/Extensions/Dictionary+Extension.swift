//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import Foundation

extension [String: String] {

	/// Encodes the key-values pairs in `application/x-www-form-urlencoded` format.
	///
	/// - Returns: The encoded string.
	func urlEncoded() -> String {
		map { key, value in
			"\(key.escape())=\(value.escape())"
		}.joined(separator: "&")
	}
}
