//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

/// The Auth Cloud Api Registration view.
final class AuthCloudApiRegistrationScreen: BaseScreen, Screen {

	// MARK: - UI

	/// The title label.
	private let titleLabel = NSLabel(text: L10n.AuthCloudApiRegistration.title, style: .title)

	/// The text field for the enrollment response.
	private let enrollResponseField = NSTextField(placeholder: L10n.AuthCloudApiRegistration.enrollResponsePlaceholder)

	/// The text field for the app link URI.
	private let appLinkUriField = NSTextField(placeholder: L10n.AuthCloudApiRegistration.appLinkUriPlaceholder)

	/// The error label.
	private let errorLabel = NSLabel(style: .error)

	/// The confirm button.
	private let confirmButton = OutlinedButton(title: L10n.AuthCloudApiRegistration.confirm)

	/// The cancel button.
	private let cancelButton = OutlinedButton(title: L10n.AuthCloudApiRegistration.cancel)

	// MARK: - Properties

	/// The view model.
	var viewModel: AuthCloudApiRegistrationViewModel!

	/// Thread safe bag that disposes added disposables.
	private let disposeBag = DisposeBag()

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameter viewModel: The view model.
	init(viewModel: AuthCloudApiRegistrationViewModel) {
		self.viewModel = viewModel
		super.init()
	}

	/// :nodoc:
	deinit {
		os_log("AuthCloudApiRegistrationScreen", log: OSLog.deinit, type: .debug)
	}
}

// MARK: - Lifecycle

extension AuthCloudApiRegistrationScreen {

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
private extension AuthCloudApiRegistrationScreen {

	func setupUI() {
		setupTitleLabel()
		setupEnrollResponseField()
		setupAppLinkUriField()
		setupErrorLabel()
		setupConfirmButton()
		setupCancelButton()
	}

	func setupTitleLabel() {
		titleLabel.do {
			addItemToTop($0, topSpacing: 32)
		}
	}

	func setupEnrollResponseField() {
		enrollResponseField.do {
			addItem($0, topSpacing: 32)
			$0.setHeight(with: 40)
		}
	}

	func setupAppLinkUriField() {
		appLinkUriField.do {
			addItem($0, topSpacing: 16)
			$0.setHeight(with: 40)
		}
	}

	func setupErrorLabel() {
		errorLabel.do {
			addItem($0, topSpacing: 5)
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

// MARK: - Binding

/// :nodoc:
private extension AuthCloudApiRegistrationScreen {

	func bindViewModel() {
		assert(viewModel != nil)
		let input = AuthCloudApiRegistrationViewModel.Input(enrollResponse: enrollResponseField.rx.text.asDriver(),
		                                                    appLinkUri: appLinkUriField.rx.text.asDriver(),
		                                                    confirmTrigger: confirmButton.rx.tap.asDriver(),
		                                                    cancelTrigger: cancelButton.rx.tap.asDriver())
		let output = viewModel.transform(input: input)
		[output.confirm.drive(),
		 output.cancel.drive(),
		 output.validationError.drive(errorLabel.rx.text),
		 output.error.drive(rx.error)]
			.forEach { $0.disposed(by: disposeBag) }
	}
}
