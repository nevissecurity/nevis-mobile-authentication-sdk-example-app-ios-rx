//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication
import RxCocoa
import RxSwift

/// Navigation parameter of the Select Authenticator view.
enum SelectAuthenticatorParameter: NavigationParameterizable {
	/// Represents authenticator selection.
	///
	///  - Parameters:
	///    - authenticatorItems: The list of authenticator items.
	///    - handler: The authenticator selection handler.
	case select(authenticatorItems: [AuthenticatorItem],
	            handler: AuthenticatorSelectionHandler)
}

/// View model of Authenticator Selection view.
final class SelectAuthenticatorViewModel {

	// MARK: - Properties

	/// The application coordinator.
	private let appCoordinator: AppCoordinator

	/// The list of authenticator items.
	private var authenticatorItems = [AuthenticatorItem]()

	/// The authenticator selection handler.
	private var handler: AuthenticatorSelectionHandler?

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameters:
	///   - appCoordinator: The application coordinator.
	///   - parameter: The navigation parameter.
	init(appCoordinator: AppCoordinator,
	     parameter: NavigationParameterizable? = nil) {
		self.appCoordinator = appCoordinator
		setParameter(parameter as? SelectAuthenticatorParameter)
	}

	/// :nodoc:
	deinit {
		os_log("SelectAuthenticatorViewModel", log: OSLog.deinit, type: .debug)
		// If it is not nil at this moment, it means that a concurrent operation will be started
		handler?.cancel()
	}
}

// MARK: - ScreenViewModel

extension SelectAuthenticatorViewModel: ScreenViewModel {

	/// The input of the view model.
	struct Input {
		/// Observable sequence used for starting to load the authenticators.
		let loadTrigger: Driver<()>
		/// Observable sequence used for selecting an authenticator at given index path.
		let selectAuthenticator: Driver<any Authenticator>
	}

	/// The output of the view model.
	struct Output {
		/// Observable sequence used for listening to authenticator items event.
		let authenticators: Driver<[AuthenticatorItem]>
		/// Observable sequence used for listening to authenticator selection event.
		let selection: Driver<()>
	}

	/// Performs pure transformation of a user `Input` to the `Output`.
	///
	/// - Parameter input: The input need to be transformed.
	/// - Returns: The transformed output.
	func transform(input: Input) -> Output {
		let authenticators = input.loadTrigger
			.flatMapLatest { [unowned self] _ in
				Driver.just(self.authenticatorItems)
			}

		let selection = input.selectAuthenticator
			.asObservable()
			.flatMap(select(authenticator:))
			.asDriverOnErrorJustComplete()

		return Output(authenticators: authenticators,
		              selection: selection)
	}
}

// MARK: - Actions

private extension SelectAuthenticatorViewModel {

	/// Handles the recevied parameter.
	///
	/// - Parameter paramter: The parameter to handle.
	func setParameter(_ parameter: SelectAuthenticatorParameter?) {
		guard let parameter else {
			preconditionFailure("Parameter type mismatch!")
		}

		switch parameter {
		case let .select(authenticatorItems, handler):
			self.authenticatorItems = authenticatorItems
			self.handler = handler
		}
	}

	/// Invokes the authenticator selection handler.
	///
	/// - Parameter authenticator: The selected authenticator.
	/// - Returns: An observable sequence.
	func select(authenticator: any Authenticator) -> Observable<()> {
		Observable.create {
			self.handler?.aaid(authenticator.aaid)
			self.handler = nil
			$0.onNext(())
			$0.onCompleted()
			return Disposables.create()
		}
	}
}
