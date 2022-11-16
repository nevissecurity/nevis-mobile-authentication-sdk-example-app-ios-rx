//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import Foundation

extension BusinessError: LocalizedError {
	public var errorDescription: String? {
		switch self {
		case .authenticatorNotFound:
			return L10n.Error.Business.authenticatorNotFound
		case .deviceInformationNotFound:
			return L10n.Error.Business.deviceInformationNotFound
		case .accountsNotFound:
			return L10n.Error.Business.accountsNotFound
		case .loginFailed:
			return L10n.Error.Business.loginFailed
		}
	}
}
