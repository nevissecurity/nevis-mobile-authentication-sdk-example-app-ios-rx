//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2023. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication

/// Information about an authenticator.
extension Authenticator {

	/// Returns whether the user is enrolled to this authenticator.
	///
	/// - Parameter username: the username.
	/// - Returns: `true` if the user is enrolled, `flase` otherwise.
	func isEnrolled(username: Username) -> Bool {
		switch userEnrollment {
		case let enrollment as SdkUserEnrollment:
			return enrollment.isEnrolled(username)
		case let enrollment as OsUserEnrollment:
			return enrollment.isEnrolled()
		default:
			return false
		}
	}
}
