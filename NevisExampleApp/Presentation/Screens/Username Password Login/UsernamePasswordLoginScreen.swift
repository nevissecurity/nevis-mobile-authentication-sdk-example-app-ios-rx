//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

/// The Username Password Login view.
final class UsernamePasswordLoginScreen: BaseScreen, Screen {

	// MARK: - UI

	/// The title label.
	private let titleLabel = NSLabel(text: L10n.UsernamePasswordLogin.title, style: .title)

	/// The text field for the username.
	private let usernameField = NSTextField(placeholder: L10n.UsernamePasswordLogin.usernamePlaceholder, returnKeyType: .next)

	/// The text field for the password.
	private let passwordField = NSTextField(placeholder: L10n.UsernamePasswordLogin.passwordPlaceholder)

	/// The confirm button.
	private let confirmButton = OutlinedButton(title: L10n.UsernamePasswordLogin.confirm)

	/// The cancel button.
	private let cancelButton = OutlinedButton(title: L10n.UsernamePasswordLogin.cancel)

	// MARK: - Properties

	/// The view model.
	var viewModel: UsernamePasswordLoginViewModel!

	/// Thread safe bag that disposes added disposables.
	private let disposeBag = DisposeBag()

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameter viewModel: The view model.
	init(viewModel: UsernamePasswordLoginViewModel) {
		self.viewModel = viewModel
		super.init()
	}

	/// :nodoc:
	deinit {
		os_log("UsernamePasswordLoginScreen", log: OSLog.deinit, type: .debug)
	}
}

// MARK: - Lifecycle

extension UsernamePasswordLoginScreen {

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
private extension UsernamePasswordLoginScreen {

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
extension UsernamePasswordLoginScreen: UITextFieldDelegate {
	func textFieldShouldReturn(_: UITextField) -> Bool {
		passwordField.becomeFirstResponder()
		return true
	}
}

// MARK: - Binding

/// :nodoc:
private extension UsernamePasswordLoginScreen {

	func bindViewModel() {
		assert(viewModel != nil)
		let input = UsernamePasswordLoginViewModel.Input(username: usernameField.rx.text.orEmpty.asDriver(),
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
