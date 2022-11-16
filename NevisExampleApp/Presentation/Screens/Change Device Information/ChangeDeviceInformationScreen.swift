//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import RxSwift
import UIKit

/// The Change Device Information view.
final class ChangeDeviceInformationScreen: BaseScreen, Screen {

	// MARK: - UI

	/// The title label.
	private let titleLabel = NSLabel(text: L10n.ChangeDeviceInformation.title, style: .title)

	/// The description label.
	private let descriptionLabel = NSLabel(style: .normal)

	/// The text field for the new device name.
	private let nameField = NSTextField(placeholder: L10n.ChangeDeviceInformation.namePlaceholder)

	/// The confirm button.
	private let confirmButton = OutlinedButton(title: L10n.ChangeDeviceInformation.confirm)

	/// The cancel button.
	private let cancelButton = OutlinedButton(title: L10n.ChangeDeviceInformation.cancel)

	// MARK: - Properties

	/// The view model.
	var viewModel: ChangeDeviceInformationViewModel!

	/// Thread safe bag that disposes added disposables.
	private let disposeBag = DisposeBag()

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameter viewModel: The view model.
	init(viewModel: ChangeDeviceInformationViewModel) {
		self.viewModel = viewModel
		super.init()
	}

	/// :nodoc:
	deinit {
		os_log("ChangeDeviceInformationScreen", log: OSLog.deinit, type: .debug)
	}
}

// MARK: - Lifecycle

extension ChangeDeviceInformationScreen {

	/// Override of the `viewDidLoad()` lifecycle method. Sets up the user interface.
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
		// do nothing
	}
}

// MARK: - Setups

/// :nodoc:
private extension ChangeDeviceInformationScreen {

	func setupUI() {
		setupTitleLabel()
		setupDescriptionLabel()
		setupNameField()
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

	func setupNameField() {
		nameField.do {
			addItem($0, topSpacing: 32)
			$0.setHeight(with: 40)
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
		nameField.becomeFirstResponder()
	}
}

// MARK: - Binding

/// :nodoc:
private extension ChangeDeviceInformationScreen {

	func bindViewModel() {
		assert(viewModel != nil)
		let loadTrigger = rx.viewDidAppear
			.take(1)
			.mapToVoid()
			.asDriverOnErrorJustComplete()
		let input = ChangeDeviceInformationViewModel.Input(loadTrigger: loadTrigger,
		                                                   name: nameField.rx.text.orEmpty.asDriver(),
		                                                   confirmTrigger: confirmButton.rx.tap.asDriver(),
		                                                   cancelTrigger: cancelButton.rx.tap.asDriver())
		let output = viewModel.transform(input: input)
		[output.description.drive(descriptionLabel.rx.text),
		 output.confirm.drive(),
		 output.cancel.drive(),
		 output.loading.drive(rx.isLoading),
		 output.error.drive(rx.error)]
			.forEach { $0.disposed(by: disposeBag) }
	}
}
