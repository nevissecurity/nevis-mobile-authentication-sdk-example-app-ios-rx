//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication

/// Information about an authenticator.
extension Authenticator {
	/// Returns the localized title.
	var localizedTitle: String {
		switch aaid {
		case AuthenticatorAaid.Pin.rawValue:
			return L10n.Authenticator.Pin.title
		case AuthenticatorAaid.FaceRecognition.rawValue:
			return L10n.Authenticator.FaceRecognition.title
		case AuthenticatorAaid.Fingerprint.rawValue:
			return L10n.Authenticator.Fingerprint.title
		case AuthenticatorAaid.DevicePasscode.rawValue:
			return L10n.Authenticator.DevicePasscode.title
		default:
			return String()
		}
	}
}
