//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import Foundation

/// Object describing a login request.
struct LoginRequest: Encodable {

	// MARK: - Properties

	/// The url of the login endpoint.
	let url: URL

	/// The username.
	let username: String

	/// The password.
	let password: String

	// MARK: - CodingKey

	/// Enumeration for keys used during encoding.
	enum CodingKeys: String, CodingKey {
		/// Key for the username.
		case username = "isiwebuserid"
		/// Key for the password.
		case password = "isiwebpasswd"
	}

	// MARK: - Encodable

	/// Encodes this value into the given encoder.
	///
	/// - Parameter encoder: The encoder to write data to.
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(username, forKey: .username)
		try container.encode(password, forKey: .password)
	}
}
