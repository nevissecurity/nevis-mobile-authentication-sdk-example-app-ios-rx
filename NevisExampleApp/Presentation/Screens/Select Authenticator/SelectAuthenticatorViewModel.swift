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
	///    - authenticators: The list of authenticators.
	///    - handler: The authenticator selection handler.
	case select(authenticators: Set<Authenticator>,
	            handler: AuthenticatorSelectionHandler)
}

/// View model of Authenticator Selection view.
final class SelectAuthenticatorViewModel {

	// MARK: - Properties

	/// The application coordinator.
	private let appCoordinator: AppCoordinator

	/// The list of authenticators.
	private var authenticators = Set<Authenticator>()

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
		let selectAuthenticator: Driver<Authenticator>
	}

	/// The output of the view model.
	struct Output {
		/// Observable sequence used for listening to authenticators event.
		let authenticators: Driver<Set<Authenticator>>
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
				Driver.just(self.authenticators)
			}

		let selection = input.selectAuthenticator
			.asObservable()
			.flatMap { [unowned self] authenticator -> Observable<()> in
				if let enrollment = authenticator.userEnrollment as? OsUserEnrollment, !enrollment.isEnrolled() {
					// The selected authenticator is an OS based authenticator (Face/Touch ID)
					// But the user is not enrolled
					return .just(self.appCoordinator.navigateToNotEnrolledAuthenticator())
				}

				return self.select(authenticator: authenticator)
			}
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
		guard let parameter = parameter else {
			preconditionFailure("Parameter type mismatch!")
		}

		switch parameter {
		case let .select(authenticators, handler):
			self.authenticators = authenticators
			self.handler = handler
		}
	}

	/// Invokes the authenticator selection handler.
	///
	/// - Parameter authenticator: The selected authenticator.
	/// - Returns: An observable sequence.
	func select(authenticator: Authenticator) -> Observable<()> {
		Observable.create {
			self.handler?.aaid(authenticator.aaid)
			self.handler = nil
			$0.onNext(())
			$0.onCompleted()
			return Disposables.create()
		}
	}
}
