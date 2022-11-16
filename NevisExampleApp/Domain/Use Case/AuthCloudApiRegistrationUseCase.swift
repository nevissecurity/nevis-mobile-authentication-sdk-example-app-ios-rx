//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication
import RxSwift

/// Use case for Auth Cloud registration.
protocol AuthCloudApiRegistrationUseCase {

	/// Registers based on the enrollment response or the app link URI.
	///
	/// - Parameters:
	///   - enrollResponse: The response of the Cloud HTTP API to the enroll endpoint.
	///   - appLinkUri: The value of the `appLinkUri` attribute in the enroll response sent by the server.
	/// - Returns: The observable sequence that will emit an ``OperationResponse`` object.
	func execute(enrollResponse: String?, appLinkUri: String?) -> Observable<OperationResponse>
}
