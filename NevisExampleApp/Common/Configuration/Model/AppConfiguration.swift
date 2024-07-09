//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication

/// Object describing application configuration
struct AppConfiguration: Codable {

	// MARK: - Properties

	/// The login configuration.
	let loginConfiguration: LoginConfiguration

	/// The Nevis Mobile Authentication SDK configuration.
	let sdkConfiguration: Configuration

	/// The allowed authenticators.
	let authenticatorWhitelist: [AuthenticatorAaid]

	// MARK: - CodingKey

	/// Enumeration for keys used during coding.
	enum CodingKeys: String, CodingKey {
		/// Key for the login configuration.
		case loginConfiguration = "login"
		/// Key for the SDK configuration.
		case sdkConfiguration = "sdk"
		/// Key for the authenticator whitelist.
		case authenticatorWhitelist

		/// Enumeration for the nested SDK configuration keys used during coding.
		enum NestedCodingKeys: String, CodingKey {
			/// Key for the base URL.
			case baseUrl
			/// Key for the host name.
			case hostName
			/// Key for the registration request path.
			case registrationRequestPath
			/// Key for the registration response path.
			case registrationResponsePath
			/// Key for the authentication request path.
			case authenticationRequestPath
			/// Key for the authentication response path.
			case authenticationResponsePath
			/// Key for the deregistration request path.
			case deregistrationRequestPath
			/// Key for the dispatch target resource path.
			case dispatchTargetResourcePath
			/// Key for the authentication max retries.
			case authenticationMaxRetries
			/// Key for the authentication retry interval.
			case authenticationRetryIntervalInSeconds
			/// Key for the network timeout.
			case networkTimeoutInSeconds
			/// Key for the user interaction timeout.
			case userInteractionTimeoutInSeconds
		}
	}

	// MARK: - Decodable

	/// Creates a new instance by decoding from the given decoder.
	///
	/// - Parameter decoder: The decoder to read data from.
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		self.loginConfiguration = try container.decode(LoginConfiguration.self, forKey: .loginConfiguration)
		let sdkContainer = try container.nestedContainer(keyedBy: CodingKeys.NestedCodingKeys.self, forKey: .sdkConfiguration)
		let hostName = try sdkContainer.decodeIfPresent(String.self, forKey: .hostName)
		if let hostName {
			// using the convenience initializer
			self.sdkConfiguration = Configuration(authCloudHostname: hostName)
		}
		else {
			self.sdkConfiguration = try container.decode(Configuration.self, forKey: .sdkConfiguration)
		}
		self.authenticatorWhitelist = try container.decode([AuthenticatorAaid].self, forKey: .authenticatorWhitelist)
	}
}
