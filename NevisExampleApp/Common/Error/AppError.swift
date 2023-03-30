//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import Foundation

/// App specific errors.
enum AppError: Error {
	/// App configuration load error.
	case loadAppConfigurationError
	/// Login configuration read error.
	case readLoginConfigurationError
	/// No ccokie were received during login.
	case cookieNotFound
	/// No PIN authenticator found in the list of registered authenticators.
	case pinAuthenticatorNotFound
}

// MARK: - LocalizedError

extension AppError: LocalizedError {
	public var errorDescription: String? {
		switch self {
		case .loadAppConfigurationError:
			return L10n.Error.App.loadAppConfigurationError
		case .readLoginConfigurationError:
			return L10n.Error.App.readLoginConfigurationError
		case .cookieNotFound:
			return L10n.Error.App.cookieNotFound
		case .pinAuthenticatorNotFound:
			return L10n.Error.App.pinAuthenticatorNotFound
		}
	}
}
