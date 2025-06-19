//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication
import RxCocoa
import RxSwift

// MARK: - Navigation

/// Navigation parameter of the Credential view.
protocol CredentialParameter: NavigationParameterizable {}

/// Navigation parameter of the Credential view in case of PIN authenticator.
enum PinParameter: CredentialParameter {
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
	///    - handler: The PIN verification handler.
	case verification(protectionStatus: PinAuthenticatorProtectionStatus,
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

/// Navigation parameter of the Credential view in case of Password authenticator.
enum PasswordParameter: CredentialParameter {
	/// Represents Password enrollment.
	///
	///  - Parameters:
	///    - lastRecoverableError: The object that informs that an error occurred during Password enrollment.
	///    - handler: The Password enrollment handler.
	case enrollment(lastRecoverableError: PasswordEnrollmentError?,
	                handler: PasswordEnrollmentHandler)

	/// Represents Password verification.
	///
	///  - Parameters:
	///    - protectionStatus: The object describing the Password authenticator protection status.
	///    - handler: The Password verification handler.
	case verification(protectionStatus: PasswordAuthenticatorProtectionStatus,
	                  handler: PasswordUserVerificationHandler)

	/// Represents Password change.
	///
	///  - Parameters:
	///    - protectionStatus: The object describing the Password authenticator protection status.
	///    - lastRecoverableError: The object that informs that an error occurred during Password change.
	///    - handler: The Password change handler.
	case credentialChange(protectionStatus: PasswordAuthenticatorProtectionStatus,
	                      lastRecoverableError: PasswordChangeRecoverableError?,
	                      handler: PasswordChangeHandler)
}

// MARK: - View model

/// View model of Credential view.
final class CredentialViewModel {

	/// Available Credential operations.
	private enum CredentialOperation {
		/// Enrollment operation.
		case enrollment
		/// Change operation.
		case credentialChange
		/// Verification operation.
		case verification
	}

	// MARK: - Properties

	/// The current Credential type.
	private var credentialType: AuthenticatorAaid = .Pin

	/// The current operation.
	private var operation: CredentialOperation = .enrollment

	/// An observable sequence that can be used for tracking the Credential protection status.
	private let credentialProtectionInfoSubject = BehaviorRelay<CredentialProtectionInformation>(value: CredentialProtectionInformation())

	/// The cooldown timer.
	private var coolDownTimer: InteractionCountDownTimer?

	// MARK: Pin

	/// The PIN authenticator protection status.
	private var pinProtectionStatus: PinAuthenticatorProtectionStatus?

	/// Error that can occur during PIN enrollment.
	private var pinEnrollmentError: PinEnrollmentError?

	/// Error that can occur during PIN change.
	private var pinCredentialChangeError: PinChangeRecoverableError?

	/// The PIN enrollment handler.
	private var pinEnrollmentHandler: PinEnrollmentHandler?

	/// The PIN verification handler.
	private var pinVerificationHandler: PinUserVerificationHandler?

	/// The PIN change handler.
	private var pinCredentialChangeHandler: PinChangeHandler?

	// MARK: Password

	/// The Password authenticator protection status.
	private var passwordProtectionStatus: PasswordAuthenticatorProtectionStatus?

	/// Error that can occur during Password enrollment.
	private var passwordEnrollmentError: PasswordEnrollmentError?

	/// Error that can occur during Password change.
	private var passwordCredentialChangeError: PasswordChangeRecoverableError?

	/// The Password enrollment handler.
	private var passwordEnrollmentHandler: PasswordEnrollmentHandler?

	/// The Password verification handler.
	private var passwordVerificationHandler: PasswordUserVerificationHandler?

	/// The Password change handler.
	private var passwordCredentialChangeHandler: PasswordChangeHandler?

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameters:
	///   - parameter: The navigation parameter.
	init(parameter: NavigationParameterizable? = nil) {
		setParameter(parameter as? CredentialParameter)
	}

	deinit {
		logger.deinit("CredentialViewModel")
		// If it is not nil at this moment, it means that a concurrent operation will be started
		pinEnrollmentHandler?.cancel()
		pinVerificationHandler?.cancel()
		pinCredentialChangeHandler?.cancel()

		passwordEnrollmentHandler?.cancel()
		passwordVerificationHandler?.cancel()
		passwordCredentialChangeHandler?.cancel()
	}
}

// MARK: - ScreenViewModel

extension CredentialViewModel: ScreenViewModel {

	/// The input of the view model.
	struct Input {
		/// Observable sequence used for listening to Credential.
		let oldCredential: Driver<String>
		/// Observable sequence used for listening to Credential confirmation.
		let credential: Driver<String>
		/// Observable sequence used for clearing the state.
		let clearTrigger: Driver<()>
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
		/// Observable sequence used for listening to actual credentail type.
		let credentialType: Driver<AuthenticatorAaid>
		/// Observable sequence used for listening to whether Credential confirmation is needed.
		let hideOldCredential: Driver<Bool>
		/// Observable sequence used for clearing the state.
		let clear: Driver<()>
		/// Observable sequence used for listening to confirm event.
		let confirm: Driver<()>
		/// Observable sequence used for listening to cancel event.
		let cancel: Driver<()>
		/// Observable sequence used for listening to error events.
		let error: Driver<Error>
		/// Observable sequence used for listening to Credential protection events.
		let credentialProtectionInformation: Driver<CredentialProtectionInformation>
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
		let hideOldCredential = Driver.just(operation != .credentialChange)
		let credentialType = Driver.just(credentialType)

		handleProtectionStatus()

		let clear = input.clearTrigger
			.asObservable()
			.flatMap(clear)
			.asDriverOnErrorJustComplete()

		let confirm = input.confirmTrigger
			.withLatestFrom(Driver.combineLatest(input.oldCredential, input.credential))
			.asObservable()
			.flatMap(confirm(oldCredential:credential:))
			.trackError(errorTracker)
			.asDriverOnErrorJustComplete()

		let cancel = input.cancelTrigger
			.do(onNext: cancel)

		let error = errorTracker.asDriver()
		let credentialProtectionInformation = credentialProtectionInfoSubject.asDriver()
		return Output(title: title,
		              description: description,
		              lastRecoverableError: lastRecoverableError,
		              credentialType: credentialType,
		              hideOldCredential: hideOldCredential,
		              clear: clear,
		              confirm: confirm,
		              cancel: cancel,
		              error: error,
		              credentialProtectionInformation: credentialProtectionInformation)
	}
}

// MARK: - Actions

private extension CredentialViewModel {

	/// Handles the recevied parameter.
	///
	/// - Parameter paramter: The parameter to handle.
	func setParameter(_ parameter: CredentialParameter?) {
		guard let parameter else {
			preconditionFailure("Parameter type mismatch!")
		}

		if let parameter = parameter as? PinParameter {
			credentialType = .Pin
			switch parameter {
			case let .enrollment(error, handler):
				operation = .enrollment
				pinEnrollmentError = error
				pinEnrollmentHandler = handler
			case let .verification(status, handler):
				operation = .verification
				pinProtectionStatus = status
				pinVerificationHandler = handler
			case let .credentialChange(status, error, handler):
				operation = .credentialChange
				pinProtectionStatus = status
				pinCredentialChangeError = error
				pinCredentialChangeHandler = handler
			}
		}
		else if let parameter = parameter as? PasswordParameter {
			credentialType = .Password
			switch parameter {
			case let .enrollment(error, handler):
				operation = .enrollment
				passwordEnrollmentError = error
				passwordEnrollmentHandler = handler
			case let .verification(status, handler):
				operation = .verification
				passwordProtectionStatus = status
				passwordVerificationHandler = handler
			case let .credentialChange(status, error, handler):
				operation = .credentialChange
				passwordProtectionStatus = status
				passwordCredentialChangeError = error
				passwordCredentialChangeHandler = handler
			}
		}
		else {
			preconditionFailure("Parameter type mismatch!")
		}
	}

	/// Returns the actual screen title based on the operation and credential type.
	///
	/// - Returns: The actual screen title based on the operation and credential type.
	func title() -> String {
		switch operation {
		case .enrollment where credentialType == AuthenticatorAaid.Pin:
			L10n.Credential.Pin.Enrollment.title
		case .verification where credentialType == AuthenticatorAaid.Pin:
			L10n.Credential.Pin.Verify.title
		case .credentialChange where credentialType == AuthenticatorAaid.Pin:
			L10n.Credential.Pin.Change.title
		case .enrollment where credentialType == AuthenticatorAaid.Password:
			L10n.Credential.Password.Enrollment.title
		case .verification where credentialType == AuthenticatorAaid.Password:
			L10n.Credential.Password.Verify.title
		case .credentialChange where credentialType == AuthenticatorAaid.Password:
			L10n.Credential.Password.Change.title
		default:
			String()
		}
	}

	/// Returns the actual screen description based on the operation and credential type.
	///
	/// - Returns: The actual screen description based on the operation and credential type.
	func description() -> String {
		switch operation {
		case .enrollment where credentialType == AuthenticatorAaid.Pin:
			L10n.Credential.Pin.Enrollment.description
		case .verification where credentialType == AuthenticatorAaid.Pin:
			L10n.Credential.Pin.Verify.description
		case .credentialChange where credentialType == AuthenticatorAaid.Pin:
			L10n.Credential.Pin.Change.description
		case .enrollment where credentialType == AuthenticatorAaid.Password:
			L10n.Credential.Password.Enrollment.description
		case .verification where credentialType == AuthenticatorAaid.Password:
			L10n.Credential.Password.Verify.description
		case .credentialChange where credentialType == AuthenticatorAaid.Password:
			L10n.Credential.Password.Change.description
		default:
			String()
		}
	}

	/// Returns the actual last recoverable error based on the operation and credential type.
	///
	/// - Returns: The actual last recoverable error based on the operation and credential type.
	func lastRecoverableError() -> String {
		switch operation {
		case .enrollment:
			pinEnrollmentError?.localizedDescription ?? passwordEnrollmentError?.localizedDescription ?? String()
		case .verification:
			String()
		case .credentialChange:
			pinCredentialChangeError?.localizedDescription ?? passwordCredentialChangeError?.localizedDescription ?? String()
		}
	}

	/// Clears the state of the view model.
	///
	/// - Returns: An observable sequence.
	func clear() -> Observable<()> {
		Observable.create {
			self.pinEnrollmentHandler = nil
			self.pinVerificationHandler = nil
			self.pinCredentialChangeHandler = nil

			self.passwordEnrollmentHandler = nil
			self.passwordVerificationHandler = nil
			self.passwordCredentialChangeHandler = nil

			$0.onCompleted()
			return Disposables.create()
		}
	}

	/// Confirms the given Credentials.
	///
	/// - Parameters:
	///  - oldCredential: The old Credential.
	///  - credential: The Credential.
	/// - Returns: An observable sequence.
	func confirm(oldCredential: String, credential: String) -> Observable<()> {
		logger.sdk("Confirming entered credentials.")
		return Observable.create {
			switch self.operation {
			case .enrollment:
				self.pinEnrollmentHandler?.pin(credential)
				self.passwordEnrollmentHandler?.password(credential)
			case .verification:
				self.pinVerificationHandler?.verify(credential)
				self.passwordVerificationHandler?.verify(credential)
			case .credentialChange:
				self.pinCredentialChangeHandler?.pins(oldCredential, credential)
				self.passwordCredentialChangeHandler?.passwords(oldCredential, credential)
			}

			$0.onCompleted()
			return Disposables.create()
		}
	}

	/// Cancels the actual operation.
	func cancel() {
		switch operation {
		case .enrollment:
			logger.sdk("Cancelling credential enrollment.")
			pinEnrollmentHandler?.cancel()
			pinEnrollmentHandler = nil
			passwordEnrollmentHandler?.cancel()
			passwordEnrollmentHandler = nil
		case .verification:
			logger.sdk("Cancelling credential verification.")
			pinVerificationHandler?.cancel()
			pinVerificationHandler = nil
			passwordVerificationHandler?.cancel()
			passwordVerificationHandler = nil
		case .credentialChange:
			logger.sdk("Cancelling credential change.")
			pinCredentialChangeHandler?.cancel()
			pinCredentialChangeHandler = nil
			passwordCredentialChangeHandler?.cancel()
			passwordCredentialChangeHandler = nil
		}
	}

	/// Handles the authenticator protection status.
	func handleProtectionStatus() {
		if case .Pin = credentialType {
			switch pinProtectionStatus {
			case .Unlocked, .none:
				logger.sdk("PIN authenticator is unlocked.")
				credentialProtectionInfoSubject.accept(CredentialProtectionInformation())
			case let .LastAttemptFailed(remainingTries, coolDown):
				logger.sdk("Last attempt failed using the PIN authenticator.")
				logger.sdk("Remaining tries: %d, cool down period: %d.", .black, .debug, remainingTries, coolDown)
				let info = CredentialProtectionInformation(message: pinProtectionStatus?.localizedDescription ?? String(),
				                                           isInCoolDown: coolDown > 0)
				credentialProtectionInfoSubject.accept(info)

				if coolDown > 0 {
					startCoolDownTimer(with: coolDown, remainingTries: remainingTries)
				}
			case .LockedOut:
				logger.sdk("PIN authenticator is locked.")
				let info = CredentialProtectionInformation(message: pinProtectionStatus?.localizedDescription ?? String())
				credentialProtectionInfoSubject.accept(info)
			case .some:
				logger.sdk("Unknown PIN authenticator protection status.")
				credentialProtectionInfoSubject.accept(CredentialProtectionInformation())
			}
		}
		else if case .Password = credentialType {
			switch passwordProtectionStatus {
			case .Unlocked, .none:
				logger.sdk("Password authenticator is unlocked.")
				credentialProtectionInfoSubject.accept(CredentialProtectionInformation())
			case let .LastAttemptFailed(remainingTries, coolDown):
				logger.sdk("Last attempt failed using the Password authenticator.")
				logger.sdk("Remaining tries: %d, cool down period: %d.", .black, .debug, remainingTries, coolDown)
				let info = CredentialProtectionInformation(message: passwordProtectionStatus?.localizedDescription ?? String(),
				                                           isInCoolDown: coolDown > 0)
				credentialProtectionInfoSubject.accept(info)

				if coolDown > 0 {
					startCoolDownTimer(with: coolDown, remainingTries: remainingTries)
				}
			case .LockedOut:
				logger.sdk("Password authenticator is locked.")
				let info = CredentialProtectionInformation(message: passwordProtectionStatus?.localizedDescription ?? String())
				credentialProtectionInfoSubject.accept(info)
			case .some:
				logger.sdk("Unknown Password authenticator protection status.")
				credentialProtectionInfoSubject.accept(CredentialProtectionInformation())
			}
		}
		else {
			credentialProtectionInfoSubject.accept(CredentialProtectionInformation())
		}
	}

	/// Starts the cooldown timer.
	///
	/// - Parameters:
	///  - cooldown: The cooldown of the timer.
	///  - remainingTries: The number of remaining tries.
	func startCoolDownTimer(with coolDown: Int, remainingTries: Int) {
		coolDownTimer = InteractionCountDownTimer(timerLifeTime: TimeInterval(coolDown)) { remainingCoolDown in
			let localizedDescription = switch self.credentialType {
			case .Pin:
				PinAuthenticatorProtectionStatus.LastAttemptFailed(remainingTries: remainingTries,
				                                                   coolDownTimeInSeconds: remainingCoolDown).localizedDescription
			case .Password:
				PasswordAuthenticatorProtectionStatus.LastAttemptFailed(remainingTries: remainingTries,
				                                                        coolDownTimeInSeconds: remainingCoolDown).localizedDescription
			default:
				String()
			}

			let info = CredentialProtectionInformation(message: localizedDescription,
			                                           isInCoolDown: remainingCoolDown > 0)
			self.credentialProtectionInfoSubject.accept(info)
		}

		coolDownTimer?.start()
	}
}
