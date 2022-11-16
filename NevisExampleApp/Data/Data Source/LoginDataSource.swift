//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication
import RxSwift

/// Protocol describing Login data source related operations.
protocol LoginDataSource {

	/// Sends a login request to the server.
	///
	/// - Parameter request: The request to send.
	/// - Returns: The observable sequence that will emit a ``LoginResponse`` object.
	func execute(request: LoginRequest) -> Observable<LoginResponse>
}
