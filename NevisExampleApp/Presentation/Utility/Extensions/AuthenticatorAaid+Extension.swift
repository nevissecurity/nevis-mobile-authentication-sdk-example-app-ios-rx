//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2024 Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication

/// Codable extension for AuthenticatorAaids.
extension AuthenticatorAaid: Codable {
	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		let aaid = try container.decode(String.self)
		guard let authenticatorAaid = AuthenticatorAaid(rawValue: aaid) else {
			throw NSError(domain: "AuthenticatorAaid cannot be decoced", code: 1)
		}
		self = authenticatorAaid
	}
}

extension AuthenticatorAaid {
	static func == (lhs: String, rhs: AuthenticatorAaid) -> Bool {
		rhs.rawValue == lhs
	}

	static func == (lhs: AuthenticatorAaid, rhs: String) -> Bool {
		rhs == lhs.rawValue
	}
}
