//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication

/// Object describing credentials received upon successful login.
struct Credentials {

	// MARK: - Properties

	/// The username.
	let username: String

	/// The list of cookies.
	var cookies: [HTTPCookie]?
}
