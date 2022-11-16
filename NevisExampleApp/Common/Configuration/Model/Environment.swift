//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import Foundation

/// Enumeration for the supported environments.
enum Environment {
	/// Represents Authentication Cloud environment.
	case authenticationCloud
	/// Represents Identity Suite environment.
	case identitySuite

	/// The configuration file name for an environment.
	var configFileName: String {
		switch self {
		case .authenticationCloud: return "ConfigAuthenticationCloud"
		case .identitySuite: return "ConfigIdentitySuite"
		}
	}
}
