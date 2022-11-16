//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import Foundation

/// Enumeration for business logic related errors.
enum BusinessError: Error {
	/// Represents authenticator not found error.
	case authenticatorNotFound

	/// Represents device information not found error.
	case deviceInformationNotFound

	/// Represents accounts not found error.
	case accountsNotFound

	/// Represents login failed error.
	case loginFailed
}
