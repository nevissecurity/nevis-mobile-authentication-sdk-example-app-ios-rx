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
		case Authenticator.pinAuthenticatorAaid:
			return L10n.Authenticator.Pin.title
		case Authenticator.faceRecognitionAuthenticatorAaid:
			return L10n.Authenticator.FaceRecognition.title
		case Authenticator.fingerprintAuthenticatorAaid:
			return L10n.Authenticator.Fingerprint.title
		default:
			return String()
		}
	}

	/// Returns the localized description.
	var localizedDescription: String {
		switch aaid {
		case Authenticator.pinAuthenticatorAaid:
			return L10n.Authenticator.Pin.description
		case Authenticator.faceRecognitionAuthenticatorAaid:
			return L10n.Authenticator.FaceRecognition.description
		case Authenticator.fingerprintAuthenticatorAaid:
			return L10n.Authenticator.Fingerprint.description
		default:
			return String()
		}
	}
}
