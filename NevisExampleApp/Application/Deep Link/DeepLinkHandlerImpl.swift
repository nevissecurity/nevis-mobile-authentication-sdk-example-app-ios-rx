//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import RxSwift

/// Default implementation of ``DeepLinkHandler`` protocol.
final class DeepLinkHandlerImpl {

	// MARK: - Properties

	/// Use case for decoding an Out-of-Band payload.
	private let decodePayloadUseCase: DecodePayloadUseCase

	/// Use case for starting an Out-of-Band operation.
	private let outOfBandOperationUseCase: OutOfBandOperationUseCase

	/// The response observer.
	private let responseObserver: ResponseObserver

	/// The application coordinator.
	private let coordinator: AppCoordinator

	/// An observer that will emit a ``String`` object.
	private var onOobOperation = PublishSubject<String>()

	/// Thread safe bag that disposes added disposables on `deinit`.
	private let disposeBag = DisposeBag()

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameters:
	///   - decodePayloadUseCase: Use case for decoding an Out-of-Band payload.
	///   - outOfBandOperationUseCase: Use case for processing an Out-of-Band payload.
	///   - responseObserver: The response observer.
	///   - coordinator: The application coordinator.
	init(decodePayloadUseCase: DecodePayloadUseCase,
	     outOfBandOperationUseCase: OutOfBandOperationUseCase,
	     responseObserver: ResponseObserver,
	     coordinator: AppCoordinator) {
		self.decodePayloadUseCase = decodePayloadUseCase
		self.outOfBandOperationUseCase = outOfBandOperationUseCase
		self.responseObserver = responseObserver
		self.coordinator = coordinator
	}
}

// MARK: - DeepLinkHandler

extension DeepLinkHandlerImpl: DeepLinkHandler {

	func handle(_ deepLink: DeepLink) {
		switch deepLink {
		case let .oobOperation(payload):
			process(payload: payload)
		}
	}
}

// MARK: - Private Interface

private extension DeepLinkHandlerImpl {

	/// Starts processing the payload.
	/// If an ongoing operation is in progress, asks the user for confirmation.
	///
	/// - Parameter payload: The payload need to be processed.
	func process(payload: String) {
		guard let topScreen = coordinator.topScreen else {
			return
		}

		if !(topScreen is HomeScreen) {
			confirmOperationInterrupt { confirmed in
				if confirmed {
					// During coordinator start all of the presented views and view models will be deinited.
					// In case of an ongoing operation if the SDK hangs on waiting for a handler invocation
					// the corresponding view model will cancel that in its `deinit` method.
					self.coordinator.start()
					self.internalProcess(payload: payload)
				}
			}
		}
		else {
			internalProcess(payload: payload)
		}
	}

	/// Starts processing the payload.
	///
	/// - Parameter payload: The payload need to be processed.
	func internalProcess(payload: String) {
		let activityIndicator = ActivityIndicator()
		let errorTracker = ErrorTracker()

		decodePayloadUseCase.execute(json: nil, base64UrlEncoded: payload)
			.trackError(errorTracker)
			.flatMap {
				self.outOfBandOperationUseCase.execute(payload: $0)
					.trackError(errorTracker)
					.asDriverOnErrorJustComplete()
			}
			.flatMap {
				self.responseObserver.observe(response: $0)
					.asDriverOnErrorJustComplete()
			}
			.subscribe()
			.disposed(by: disposeBag)

		guard let topScreen = coordinator.topScreen else {
			return
		}

		activityIndicator
			.asObservable()
			.bind(to: topScreen.rx.isLoading)
			.disposed(by: disposeBag)

		errorTracker
			.asObservable()
			.bind(to: topScreen.rx.error)
			.disposed(by: disposeBag)
	}

	/// Asks the user to confirm the interruption of the ongoing operation.
	///
	/// - Parameter handler: The handler that is invoked upon user decision.
	func confirmOperationInterrupt(completion handler: @escaping (Bool) -> ()) {
		let alert = UIAlertController(title: L10n.Operation.Interrupt.Alert.title,
		                              message: L10n.Operation.Interrupt.Alert.message,
		                              preferredStyle: .alert)

		let confirm = UIAlertAction(title: L10n.Operation.Interrupt.Alert.confirm,
		                            style: .default) { _ in
			handler(true)
		}
		alert.addAction(confirm)

		let cancel = UIAlertAction(title: L10n.Operation.Interrupt.Alert.cancel,
		                           style: .cancel) { _ in
			handler(false)
		}
		alert.addAction(cancel)

		coordinator.present(alert)
	}
}
