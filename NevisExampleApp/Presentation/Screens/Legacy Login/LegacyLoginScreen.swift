//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

/// The Legacy Login view.
final class LegacyLoginScreen: BaseScreen, Screen {

	// MARK: - UI

	/// The title label.
	private let titleLabel = NSLabel(text: L10n.LegacyLogin.title, style: .title)

	/// The text field for the username.
	private let usernameField = NSTextField(placeholder: L10n.LegacyLogin.usernamePlaceholder, returnKeyType: .next)

	/// The text field for the password.
	private let passwordField = NSTextField(placeholder: L10n.LegacyLogin.passwordPlaceholder)

	/// The confirm button.
	private let confirmButton = OutlinedButton(title: L10n.LegacyLogin.confirm)

	/// The cancel button.
	private let cancelButton = OutlinedButton(title: L10n.LegacyLogin.cancel)

	// MARK: - Properties

	/// The view model.
	var viewModel: LegacyLoginViewModel!

	/// Thread safe bag that disposes added disposables.
	private let disposeBag = DisposeBag()

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameter viewModel: The view model.
	init(viewModel: LegacyLoginViewModel) {
		self.viewModel = viewModel
		super.init()
	}

	/// :nodoc:
	deinit {
		os_log("LegacyLoginScreen", log: OSLog.deinit, type: .debug)
	}
}

// MARK: - Lifecycle

extension LegacyLoginScreen {

	/// Override of the `viewDidLoad()` lifecycle method. Sets up the user interface.
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		bindViewModel()
	}

	func refresh() {
		// do nothing
	}
}

// MARK: - Setups

/// :nodoc:
private extension LegacyLoginScreen {

	func setupUI() {
		setupTitleLabel()
		setupUsernameField()
		setupPasswordField()
		setupConfirmButton()
		setupCancelButton()
	}

	func setupTitleLabel() {
		titleLabel.do {
			addItemToTop($0, topSpacing: 32)
		}
	}

	func setupUsernameField() {
		usernameField.do {
			addItem($0, topSpacing: 32)
			$0.setHeight(with: 40)
			$0.delegate = self
		}
	}

	func setupPasswordField() {
		passwordField.do {
			addItem($0, topSpacing: 16)
			$0.setHeight(with: 40)
			$0.isSecureTextEntry = true
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
}

// MARK: - UITextFieldDelegate

/// :nodoc:
extension LegacyLoginScreen: UITextFieldDelegate {
	func textFieldShouldReturn(_: UITextField) -> Bool {
		passwordField.becomeFirstResponder()
		return true
	}
}

// MARK: - Binding

/// :nodoc:
private extension LegacyLoginScreen {

	func bindViewModel() {
		assert(viewModel != nil)
		let input = LegacyLoginViewModel.Input(username: usernameField.rx.text.orEmpty.asDriver(),
		                                       password: passwordField.rx.text.orEmpty.asDriver(),
		                                       confirmTrigger: confirmButton.rx.tap.asDriver(),
		                                       cancelTrigger: cancelButton.rx.tap.asDriver())
		let output = viewModel.transform(input: input)
		[output.confirm.drive(),
		 output.cancel.drive(),
		 output.loading.drive(rx.isLoading),
		 output.error.drive(rx.error)]
			.forEach { $0.disposed(by: disposeBag) }
	}
}
