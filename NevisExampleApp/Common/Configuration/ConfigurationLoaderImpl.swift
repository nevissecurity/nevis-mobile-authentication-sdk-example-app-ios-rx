//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import RxSwift

/// Default implementation of ``ConfigurationLoader`` protocol.
class ConfigurationLoaderImpl {

	// MARK: - Properties

	/// The actual environment.
	let environment: Environment

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameter environment: The actual environment.
	init(environment: Environment) {
		self.environment = environment
	}
}

// MARK: - ConfigurationLoader

extension ConfigurationLoaderImpl: ConfigurationLoader {
	func load() -> Observable<AppConfiguration> {
		Observable.create { [unowned self] observer in
			let disposable = Disposables.create()

			do {
				guard let url = Bundle.main.url(forResource: environment.configFileName,
				                                withExtension: "plist") else {
					observer.onError(OperationError(operation: .initClient,
					                                underlyingError: AppError.loadAppConfigurationError))
					return disposable
				}

				let data = try Data(contentsOf: url)
				let configuration = try PropertyListDecoder().decode(AppConfiguration.self, from: data)
				observer.onNext(configuration)
				observer.onCompleted()
			}
			catch {
				observer.onError(OperationError(operation: .initClient,
				                                underlyingError: error))
			}

			return disposable
		}
	}
}
