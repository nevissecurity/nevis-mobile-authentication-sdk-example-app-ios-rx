//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import RxCocoa

/// Navigation parameter of the Result view.
enum ResultParameter: NavigationParameterizable {
	/// Represents operation succeeded case.
	///
	///  - Parameter operation: The operation that finished successfully.
	case success(operation: Operation)

	/// Represents operation failed case.
	///
	///  - Parameter operation: The operation that failed.
	///  - Parameter description: The description of the failure.
	case failure(operation: Operation?, description: String?)
}

/// View model of Result view.
final class ResultViewModel {

	/// The available result types.
	private enum ResultType {
		/// Success result.
		case success
		/// Failure result.
		case failure
	}

	// MARK: - Properties

	/// The application coordinator.
	private let appCoordinator: AppCoordinator

	/// The type of the result.
	private var result: ResultType = .success

	/// The finished operation.
	private var operation: Operation?

	/// The description of the result.
	private var description: String?

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameters:
	///   - appCoordinator: The application coordinator.
	///   - parameter: The navigation parameter.
	init(appCoordinator: AppCoordinator,
	     parameter: NavigationParameterizable? = nil) {
		self.appCoordinator = appCoordinator
		setParameter(parameter as? ResultParameter)
	}

	deinit {
		logger.deinit("ResultViewModel")
	}
}

// MARK: - ScreenViewModel

extension ResultViewModel: ScreenViewModel {

	/// The input of the view model.
	struct Input {
		/// Observable sequence used for listening to action button tap event.
		let actionTrigger: Driver<()>
	}

	/// The output of the view model.
	struct Output {
		/// Observable sequence used for listening to actual title.
		let title: Driver<String>
		/// Observable sequence used for listening to actual description.
		let description: Driver<String?>
		/// Observable sequence used for listening to action event.
		let action: Driver<()>
	}

	/// Performs pure transformation of a user `Input` to the `Output`.
	///
	/// - Parameter input: The input need to be transformed.
	/// - Returns: The transformed output.
	func transform(input: Input) -> Output {
		let title = Driver.just(title())
		let description = Driver.just(description)
		let action = input.actionTrigger
			.do(onNext: appCoordinator.start)

		return Output(title: title,
		              description: description,
		              action: action)
	}
}

// MARK: - Actions

private extension ResultViewModel {

	/// Handles the recevied parameter.
	///
	/// - Parameter paramter: The parameter to handle.
	func setParameter(_ parameter: ResultParameter?) {
		guard let parameter else {
			preconditionFailure("Parameter type mismatch!")
		}

		switch parameter {
		case let .success(operation):
			self.operation = operation
		case let .failure(operation, description):
			result = .failure
			self.operation = operation
			self.description = description
		}
	}

	/// Returns the screen title based on the actual result type.
	///
	/// - Returns: The screen title based on the actual result type.
	func title() -> String {
		switch result {
		case .success:
			return L10n.Operation.Success.title(operation!.localizedTitle)
		case .failure:
			guard let operation else {
				return L10n.Error.App.Generic.title
			}

			return L10n.Operation.Failed.title(operation.localizedTitle)
		}
	}
}
