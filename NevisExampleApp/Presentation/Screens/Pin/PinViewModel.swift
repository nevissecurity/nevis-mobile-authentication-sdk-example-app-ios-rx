//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication
import RxCocoa
import RxSwift

/// Navigation parameter of the Pin view.
enum PinParameter: NavigationParameterizable {
	/// Represents Pin enrollment
	/// .
	///  - Parameters:
	///    - lastRecoverableError: The object that informs that an error occurred during PIN enrollment.
	///    - handler: The PIN enrollment handler.
	case enrollment(lastRecoverableError: PinEnrollmentError?,
	                handler: PinEnrollmentHandler)

	/// Represents Pin verification.
	///
	///  - Parameters:
	///    - protectionStatus: The object describing the PIN authenticator protection status.
	///    - lastRecoverableError: The object that informs that an error occurred during PIN verification.
	///    - handler: The PIN verification handler.
	case verification(protectionStatus: PinAuthenticatorProtectionStatus,
	                  lastRecoverableError: PinUserVerificationError?,
	                  handler: PinUserVerificationHandler)

	/// Represents Pin change.
	///
	///  - Parameters:
	///    - protectionStatus: The object describing the PIN authenticator protection status.
	///    - lastRecoverableError: The object that informs that an error occurred during PIN change.
	///    - handler: The PIN change handler.
	case credentialChange(protectionStatus: PinAuthenticatorProtectionStatus,
	                      lastRecoverableError: PinChangeRecoverableError?,
	                      handler: PinChangeHandler)
}

/// View model of Pin view.
final class PinViewModel {

	/// Available PIN operations.
	private enum PinOperation {
		/// PIN enrollment operation.
		case enrollment
		/// PIN change operation.
		case credentialChange
		/// PIN verification operation.
		case verification
	}

	// MARK: - Properties

	/// The logger.
	private let logger: SDKLogger

	/// The PIN authenticator protection status.
	private var protectionStatus: PinAuthenticatorProtectionStatus?

	/// Error that can occur during PIN enrollment.
	private var enrollmentError: PinEnrollmentError?

	/// Error that can occur during PIN verification.
	private var verificationError: PinUserVerificationError?

	/// Error that can occur during PIN change.
	private var credentialChangeError: PinChangeRecoverableError?

	/// The PIN enrollment handler.
	private var enrollmentHandler: PinEnrollmentHandler?

	/// The PIN verification handler.
	private var verificationHandler: PinUserVerificationHandler?

	/// The PIN change handler.
	private var credentialChangeHandler: PinChangeHandler?

	/// The current PIN operation.
	private var operation: PinOperation = .enrollment

	/// An observable sequence that can be used for tracking the PIN protection status.
	private let pinProtectionInfoSubject = BehaviorRelay<PinProtectionInformation>(value: PinProtectionInformation())

	/// The cooldown timer.
	private var coolDownTimer: InteractionCountDownTimer?

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameters:
	///   - logger: The logger.
	///   - parameter: The navigation parameter.
	init(logger: SDKLogger,
	     parameter: NavigationParameterizable? = nil) {
		self.logger = logger
		setParameter(parameter as? PinParameter)
	}

	/// :nodoc:
	deinit {
		os_log("PinViewModel", log: OSLog.deinit, type: .debug)
		// If it is not nil at this moment, it means that a concurrent operation will be started
		enrollmentHandler?.cancel()
		verificationHandler?.cancel()
		credentialChangeHandler?.cancel()
	}
}

// MARK: - ScreenViewModel

extension PinViewModel: ScreenViewModel {

	/// The input of the view model.
	struct Input {
		/// Observable sequence used for listening to Pin.
		let oldPin: Driver<String>
		/// Observable sequence used for listening to Pin confirmation.
		let pin: Driver<String>
		/// Observable sequence used for starting confirmation.
		let confirmTrigger: Driver<()>
		/// Observable sequence used for starting cancellation.
		let cancelTrigger: Driver<()>
	}

	/// The output of the view model.
	struct Output {
		/// Observable sequence used for listening to actual title.
		let title: Driver<String>
		/// Observable sequence used for listening to actual description.
		let description: Driver<String>
		/// Observable sequence used for listening to last recoverable error.
		let lastRecoverableError: Driver<String>
		/// Observable sequence used for listening to whether Pin confirmation is needed.
		let hideOldPin: Driver<Bool>
		/// Observable sequence used for listening to confirm event.
		let confirm: Driver<()>
		/// Observable sequence used for listening to cancel event.
		let cancel: Driver<()>
		/// Observable sequence used for listening to error events.
		let error: Driver<Error>
		/// Observable sequence used for listening to Pin protection events.
		let pinProtectionInformation: Driver<PinProtectionInformation>
	}

	/// Performs pure transformation of a user `Input` to the `Output`.
	///
	/// - Parameter input: The input need to be transformed.
	/// - Returns: The transformed output.
	func transform(input: Input) -> Output {
		let errorTracker = ErrorTracker()
		let title = Driver.just(title())
		let description = Driver.just(description())
		let lastRecoverableError = Driver.just(lastRecoverableError())
		let hideOldPin = Driver.just(operation != .credentialChange)

		handleProtectionStatus()
		let confirm = input.confirmTrigger
			.withLatestFrom(Driver.combineLatest(input.oldPin, input.pin))
			.asObservable()
			.flatMap(confirm(oldPin:pin:))
			.trackError(errorTracker)
			.asDriverOnErrorJustComplete()

		let cancel = input.cancelTrigger
			.do(onNext: cancel)

		let error = errorTracker.asDriver()
		let pinProtectionInformation = pinProtectionInfoSubject.asDriver()
		return Output(title: title,
		              description: description,
		              lastRecoverableError: lastRecoverableError,
		              hideOldPin: hideOldPin,
		              confirm: confirm,
		              cancel: cancel,
		              error: error,
		              pinProtectionInformation: pinProtectionInformation)
	}
}

// MARK: - Actions

private extension PinViewModel {

	/// Handles the recevied parameter.
	///
	/// - Parameter paramter: The parameter to handle.
	func setParameter(_ parameter: PinParameter?) {
		guard let parameter else {
			preconditionFailure("Parameter type mismatch!")
		}

		switch parameter {
		case let .enrollment(error, handler):
			operation = .enrollment
			enrollmentError = error
			enrollmentHandler = handler
		case let .verification(status, error, handler):
			operation = .verification
			protectionStatus = status
			verificationError = error
			verificationHandler = handler
		case let .credentialChange(status, error, handler):
			operation = .credentialChange
			protectionStatus = status
			credentialChangeError = error
			credentialChangeHandler = handler
		}
	}

	/// Returns the actual screen title based on the operation.
	///
	/// - Returns: The actual screen title based on the operation.
	func title() -> String {
		switch operation {
		case .enrollment:
			return L10n.Pin.Enrollment.title
		case .verification:
			return L10n.Pin.Verify.title
		case .credentialChange:
			return L10n.Pin.Change.title
		}
	}

	/// Returns the actual screen description based on the operation.
	///
	/// - Returns: The actual screen description based on the operation.
	func description() -> String {
		switch operation {
		case .enrollment:
			return L10n.Pin.Enrollment.description
		case .verification:
			return L10n.Pin.Verify.description
		case .credentialChange:
			return L10n.Pin.Change.description
		}
	}

	/// Returns the actual last recoverable error based on the operation.
	///
	/// - Returns: The actual last recoverable error based on the operation.
	func lastRecoverableError() -> String {
		switch operation {
		case .enrollment:
			return enrollmentError?.localizedDescription ?? String()
		case .verification:
			return verificationError?.localizedDescription ?? String()
		case .credentialChange:
			return credentialChangeError?.localizedDescription ?? String()
		}
	}

	/// Confirms the given credentials.
	///
	/// - Parameters:
	///  - oldPin: The old PIN.
	///  - pin: The PIN.
	/// - Returns: An observable sequence.
	func confirm(oldPin: String, pin: String) -> Observable<()> {
		logger.log("Confirming entered credentials.")
		return Observable.create {
			switch self.operation {
			case .enrollment:
				self.enrollmentHandler!.pin(pin)
				self.enrollmentHandler = nil
			case .verification:
				self.verificationHandler!.verify(pin)
				self.verificationHandler = nil
			case .credentialChange:
				self.credentialChangeHandler!.pins(oldPin, pin)
				self.credentialChangeHandler = nil
			}

			$0.onCompleted()
			return Disposables.create()
		}
	}

	/// Cancels the actual operation.
	func cancel() {
		switch operation {
		case .enrollment:
			logger.log("Cancelling PIN enrollment.")
			enrollmentHandler?.cancel()
			enrollmentHandler = nil
		case .verification:
			logger.log("Cancelling PIN verification.")
			verificationHandler?.cancel()
			verificationHandler = nil
		case .credentialChange:
			logger.log("Cancelling PIN change.")
			credentialChangeHandler?.cancel()
			credentialChangeHandler = nil
		}
	}

	/// Handles the PIN authenticator protection status.
	func handleProtectionStatus() {
		switch protectionStatus {
		case .Unlocked, .none:
			logger.log("PIN authenticator is unlocked.")
			pinProtectionInfoSubject.accept(PinProtectionInformation())
		case let .LastAttemptFailed(remainingTries, coolDown):
			logger.log("Last attempt failed using the PIN authenticator.")
			let info = PinProtectionInformation(message: protectionStatus?.localizedDescription ?? String(),
			                                    isInCoolDown: coolDown > 0)
			pinProtectionInfoSubject.accept(info)

			if coolDown > 0 {
				startCoolDownTimer(with: coolDown, remainingTries: remainingTries)
			}
		case .LockedOut:
			logger.log("PIN authenticator is locked.")
			let info = PinProtectionInformation(message: protectionStatus?.localizedDescription ?? String())
			pinProtectionInfoSubject.accept(info)
		case .some:
			logger.log("Unknown PIN authenticator protection status.")
			pinProtectionInfoSubject.accept(PinProtectionInformation())
		}
	}

	/// Starts the cooldown timer.
	///
	/// - Parameters:
	///  - cooldown: The cooldown of the timer.
	///  - remainingTries: The number of remaining tries.
	func startCoolDownTimer(with coolDown: Int, remainingTries: Int) {
		coolDownTimer = InteractionCountDownTimer(timerLifeTime: TimeInterval(coolDown)) { remainingCoolDown in
			let status: PinAuthenticatorProtectionStatus = .LastAttemptFailed(remainingTries: remainingTries,
			                                                                  coolDownTimeInSeconds: remainingCoolDown)
			let info = PinProtectionInformation(message: status.localizedDescription,
			                                    isInCoolDown: remainingCoolDown > 0)
			self.pinProtectionInfoSubject.accept(info)
		}

		coolDownTimer?.start()
	}
}
