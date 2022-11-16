//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import Foundation

/// Object describing a login response.
struct LoginResponse: Decodable {

	// MARK: - Properties

	/// The status.
	let status: String

	/// The external identifier.
	let extId: String

	/// The external identifier.
	var cookies: [HTTPCookie]?

	// MARK: - CodingKey

	/// Enumeration for keys used during decoding.
	enum CodingKeys: CodingKey {
		/// Key for the status.
		case status
		/// Key for the external identifier.
		case extId
	}

	// MARK: - Decodable

	/// Creates a new instance by decoding from the given decoder.
	///
	/// - Parameter decoder: The decoder to read data from.
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.status = try container.decode(String.self, forKey: .status)
		self.extId = try container.decode(String.self, forKey: .extId)
	}
}
