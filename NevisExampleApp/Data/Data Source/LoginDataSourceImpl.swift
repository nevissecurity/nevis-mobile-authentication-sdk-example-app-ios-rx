//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import RxCocoa
import RxSwift

/// Default implementation of ``LoginDataSource`` protocol.
class LoginDataSourceImpl {

	// MARK: - Properties

	/// The used URL session.
	private let session: URLSession

	// MARK: - Initialization

	/// Creates a new instance.
	init() {
		self.session = URLSession(configuration: .ephemeral,
		                          delegate: LoginSessionDelegate(),
		                          delegateQueue: nil)
	}
}

// MARK: - LoginDataSource

extension LoginDataSourceImpl: LoginDataSource {
	func execute(request: LoginRequest) -> Observable<LoginResponse> {
		do {
			var httpRequest = URLRequest(url: request.url)
			httpRequest.httpMethod = "POST"
			httpRequest.addValue("application/x-www-form-urlencoded;charset=utf-8",
			                     forHTTPHeaderField: "Content-Type")
			let data = try JSONEncoder().encode(request)
			guard let parameters = try JSONSerialization.jsonObject(with: data) as? [String: String] else {
				return Observable.error(BusinessError.loginFailed)
			}

			httpRequest.encode(parameters: parameters)
			return session.rx.response(request: httpRequest)
				.map { httpResponse, data in
					var response = try JSONDecoder().decode(LoginResponse.self, from: data)
					let cookies = HTTPCookie.cookies(withResponseHeaderFields: httpResponse.allHeaderFields as! [String: String],
					                                 for: request.url)
					response.cookies = cookies
					return response
				}
		}
		catch {
			return Observable.error(error)
		}
	}
}

// MARK: - LoginSessionDelegate

/// Login specific implementation of ``URLSessionDelegate`` protocol.
class LoginSessionDelegate: NSObject, URLSessionDelegate {

	/// Requests credentials from the delegate in response to a session-level authentication request from the remote server.
	///
	/// - Parameters:
	///   - session: The session containing the task that requested authentication.
	///   - challenge: An object that contains the request for authentication.
	///   - completionHandler: A handler that your delegate method must call.
	func urlSession(_: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> ()) {
		if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
		   let serverTrust = challenge.protectionSpace.serverTrust {
			completionHandler(.useCredential, URLCredential(trust: serverTrust))
		}
		else {
			completionHandler(.performDefaultHandling, nil)
		}
	}
}
