//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2024 Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication

extension PasswordAuthenticatorProtectionStatus {
	/// Returns the localized description.
	var localizedDescription: String {
		switch self {
		case .Unlocked:
			return String()
		case .LockedOut:
			return L10n.Credential.Password.ProtectionStatus.lockedOut
		case let .LastAttemptFailed(remainingTries, coolDown):
			var localizedDescription = ""
			switch (remainingTries, coolDown) {
			case (1, 0):
				localizedDescription = L10n.Credential.Password.ProtectionStatus.lastRetryWithoutCoolDown(remainingTries)
			case (1, 1...):
				localizedDescription = L10n.Credential.Password.ProtectionStatus.lastRetryWithCoolDown(remainingTries,
				                                                                                       String(format: "%.0f", Double(coolDown)))
			case (2..., 1...):
				localizedDescription = L10n.Credential.Password.ProtectionStatus.retriesWithCoolDown(remainingTries,
				                                                                                     String(format: "%.0f", Double(coolDown)))
			default:
				localizedDescription = L10n.Credential.Password.ProtectionStatus.retriesWithoutCoolDown(remainingTries)
			}

			return localizedDescription
		@unknown default:
			return String()
		}
	}
}
