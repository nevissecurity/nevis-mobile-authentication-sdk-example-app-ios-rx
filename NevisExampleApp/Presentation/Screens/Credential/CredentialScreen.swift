//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication
import RxSwift
import UIKit

/// The Credential view. Used for PIN / Password creation verification and change.
class CredentialScreen: BaseScreen, Screen {

	// MARK: - UI

	/// The title label.
	private let titleLabel = NSLabel(style: .title)

	/// The description label.
	private let descriptionLabel = NSLabel(style: .normal)

	/// The text field for the old credential.
	private let oldCredentialField = NSTextField(returnKeyType: .next)

	/// The text field for the credential.
	private let credentialField = NSTextField()

	/// The error label.
	private let errorLabel = NSLabel(style: .error)

	/// The information label.
	private let infoMessageLabel = NSLabel(style: .info)

	/// The confirm button.
	private let confirmButton = OutlinedButton(title: L10n.Credential.confirm)

	/// The cancel button.
	private let cancelButton = OutlinedButton(title: L10n.Credential.cancel)

	/// The toolbar for the keyboard with type *numberPad*.
	private let keyboardToolbar = UIToolbar()

	// MARK: - Properties

	/// The view model.
	var viewModel: CredentialViewModel!

	/// Thread safe bag that disposes added disposables.
	private let disposeBag = DisposeBag()

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameter viewModel: The view model.
	init(viewModel: CredentialViewModel) {
		self.viewModel = viewModel
		super.init()
	}

	/// :nodoc:
	deinit {
		os_log("CredentialScreen", log: OSLog.deinit, type: .debug)
	}
}

// MARK: - Lifecycle

extension CredentialScreen {

	/// Override of the `viewDidLoad()` lifecycle method. Sets up the user interface and binds the view model.
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		bindViewModel()
	}

	/// Override of the `viewWillAppear(_:)` lifecycle method. Sets up the text fields.
	///
	/// - parameter animated: If *true*, the view is being added to the window using an animation.
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		setupTextFields()
	}

	func refresh() {
		bindViewModel()
	}
}

// MARK: - Setups

/// :nodoc:
private extension CredentialScreen {

	func setupUI() {
		setupTitleLabel()
		setupDescriptionLabel()
		setupToolbar()
		setupOldCredentialField()
		setupCredentialField()
		setupErrorLabel()
		setupInfoMessageLabel()
		setupConfirmButton()
		setupCancelButton()
	}

	func setupTitleLabel() {
		titleLabel.do {
			addItemToTop($0, topSpacing: 32)
		}
	}

	func setupDescriptionLabel() {
		descriptionLabel.do {
			addItem($0, topSpacing: 32)
		}
	}

	func setupToolbar() {
		let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
		                                target: nil,
		                                action: nil)
		let doneButton = UIBarButtonItem(title: L10n.Credential.done,
		                                 style: .done,
		                                 target: self,
		                                 action: #selector(done))
		keyboardToolbar.do {
			$0.frame = CGRect(origin: .zero, size: CGSize(width: 100, height: 44))
			$0.setItems([flexSpace, doneButton], animated: false)
			$0.sizeToFit()
		}
	}

	func setupOldCredentialField() {
		oldCredentialField.do {
			addItem($0, topSpacing: 16)
			$0.setHeight(with: 40)
			$0.isSecureTextEntry = true
			$0.inputAccessoryView = keyboardToolbar
		}
	}

	func setupCredentialField() {
		credentialField.do {
			addItem($0, topSpacing: 16)
			$0.setHeight(with: 40)
			$0.keyboardType = .numberPad
			$0.isSecureTextEntry = true
			$0.inputAccessoryView = keyboardToolbar
		}
	}

	func setupErrorLabel() {
		errorLabel.do {
			addItem($0, topSpacing: 5)
		}
	}

	func setupInfoMessageLabel() {
		infoMessageLabel.do {
			addItem($0, topSpacing: 16)
		}
	}

	func setupConfirmButton() {
		confirmButton.do {
			addItem($0, topSpacing: 16)
			$0.setHeight(with: 40)
		}
	}

	func setupCancelButton() {
		cancelButton.do {
			addItem($0, topSpacing: 16)
			$0.setHeight(with: 40)
		}
	}

	func setupTextFields() {
		if let superview = oldCredentialField.superview, !superview.isHidden {
			oldCredentialField.becomeFirstResponder()
		}
		else {
			credentialField.becomeFirstResponder()
		}
	}
}

// MARK: - Actions

/// :nodoc:
private extension CredentialScreen {
	@objc
	func done() {
		view.endEditing(true)
	}
}

// MARK: - Binding

/// :nodoc:
private extension CredentialScreen {

	func bindViewModel() {
		assert(viewModel != nil)
		let clearTrigger = rx.viewDidDisappear
			.take(1)
			.mapToVoid()
			.asDriverOnErrorJustComplete()

		let input = CredentialViewModel.Input(oldCredential: oldCredentialField.rx.text.orEmpty.asDriver(),
		                                      credential: credentialField.rx.text.orEmpty.asDriver(),
		                                      clearTrigger: clearTrigger,
		                                      confirmTrigger: confirmButton.rx.tap.asDriver(),
		                                      cancelTrigger: cancelButton.rx.tap.asDriver())
		let output = viewModel.transform(input: input)
		[output.title.drive(titleLabel.rx.text),
		 output.description.drive(descriptionLabel.rx.text),
		 output.lastRecoverableError.drive(errorLabel.rx.text),
		 output.credentialType.drive(credentialTypeBinder),
		 output.hideOldCredential.drive(hideOldPinBinder),
		 output.clear.drive(),
		 output.confirm.drive(),
		 output.cancel.drive(),
		 output.error.drive(rx.error),
		 output.credentialProtectionInformation.drive(pinProtectionInfoBinder)]
			.forEach { $0.disposed(by: disposeBag) }
	}

	var credentialTypeBinder: Binder<AuthenticatorAaid> {
		Binder(self) { base, credentialType in
			base.oldCredentialField.do {
				$0.placeholder = credentialType == .Pin ? L10n.Credential.Pin.oldPinPlaceholder : L10n.Credential.Password.oldPasswordPlaceholder
				$0.keyboardType = credentialType == .Pin ? .numberPad : .default
			}
			base.credentialField.do {
				$0.keyboardType = credentialType == .Pin ? .numberPad : .default
			}
		}
	}

	var hideOldPinBinder: Binder<Bool> {
		Binder(self) { base, isHidden in
			base.oldCredentialField.superview?.isHidden = isHidden
		}
	}

	var pinProtectionInfoBinder: Binder<CredentialProtectionInformation> {
		Binder(self) { base, info in
			base.infoMessageLabel.text = info.message
			base.confirmButton.isEnabled = !info.isInCoolDown
			base.cancelButton.isEnabled = !info.isInCoolDown
		}
	}
}
