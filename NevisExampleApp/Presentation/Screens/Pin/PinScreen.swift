//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import RxSwift
import UIKit

/// The Pin view. Used for Pin code creation verification and change.
class PinScreen: BaseScreen, Screen {

	// MARK: - UI

	/// The title label.
	private let titleLabel = NSLabel(style: .title)

	/// The description label.
	private let descriptionLabel = NSLabel(style: .normal)

	/// The text field for the old PIN.
	private let oldPinField = NSTextField(placeholder: L10n.Pin.oldPinPlaceholder, returnKeyType: .next)

	/// The text field for the PIN.
	private let pinField = NSTextField(placeholder: L10n.Pin.pinPlaceholder)

	/// The error label.
	private let errorLabel = NSLabel(style: .error)

	/// The information label.
	private let infoMessageLabel = NSLabel(style: .info)

	/// The confirm button.
	private let confirmButton = OutlinedButton(title: L10n.Pin.confirm)

	/// The cancel button.
	private let cancelButton = OutlinedButton(title: L10n.Pin.cancel)

	/// The toolbar for the keyboard with type *numberPad*.
	private let keyboardToolbar = UIToolbar()

	// MARK: - Properties

	/// The view model.
	var viewModel: PinViewModel!

	/// Thread safe bag that disposes added disposables.
	private let disposeBag = DisposeBag()

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameter viewModel: The view model.
	init(viewModel: PinViewModel) {
		self.viewModel = viewModel
		super.init()
	}

	/// :nodoc:
	deinit {
		os_log("PinScreen", log: OSLog.deinit, type: .debug)
	}
}

// MARK: - Lifecycle

extension PinScreen {

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
private extension PinScreen {

	func setupUI() {
		setupTitleLabel()
		setupDescriptionLabel()
		setupToolbar()
		setupOldPinField()
		setupPinField()
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
		let doneButton = UIBarButtonItem(title: L10n.Pin.done,
		                                 style: .done,
		                                 target: self,
		                                 action: #selector(done))
		keyboardToolbar.do {
			$0.frame = CGRect(origin: .zero, size: CGSize(width: 100, height: 44))
			$0.setItems([flexSpace, doneButton], animated: false)
			$0.sizeToFit()
		}
	}

	func setupOldPinField() {
		oldPinField.do {
			addItem($0, topSpacing: 16)
			$0.setHeight(with: 40)
			$0.keyboardType = .numberPad
			$0.inputAccessoryView = keyboardToolbar
		}
	}

	func setupPinField() {
		pinField.do {
			addItem($0, topSpacing: 16)
			$0.setHeight(with: 40)
			$0.keyboardType = .numberPad
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
		if let superview = oldPinField.superview, !superview.isHidden {
			oldPinField.becomeFirstResponder()
		}
		else {
			pinField.becomeFirstResponder()
		}
	}
}

// MARK: - Actions

/// :nodoc:
private extension PinScreen {
	@objc
	func done() {
		view.endEditing(true)
	}
}

// MARK: - Binding

/// :nodoc:
private extension PinScreen {

	func bindViewModel() {
		assert(viewModel != nil)
		let clearTrigger = rx.viewDidDisappear
			.take(1)
			.mapToVoid()
			.asDriverOnErrorJustComplete()

		let input = PinViewModel.Input(oldPin: oldPinField.rx.text.orEmpty.asDriver(),
		                               pin: pinField.rx.text.orEmpty.asDriver(),
		                               clearTrigger: clearTrigger,
		                               confirmTrigger: confirmButton.rx.tap.asDriver(),
		                               cancelTrigger: cancelButton.rx.tap.asDriver())
		let output = viewModel.transform(input: input)
		[output.title.drive(titleLabel.rx.text),
		 output.description.drive(descriptionLabel.rx.text),
		 output.lastRecoverableError.drive(errorLabel.rx.text),
		 output.hideOldPin.drive(hideOldPinBinder),
		 output.clear.drive(),
		 output.confirm.drive(),
		 output.cancel.drive(),
		 output.error.drive(rx.error),
		 output.pinProtectionInformation.drive(pinProtectionInfoBinder)]
			.forEach { $0.disposed(by: disposeBag) }
	}

	var hideOldPinBinder: Binder<Bool> {
		Binder(self) { base, isHidden in
			base.oldPinField.superview?.isHidden = isHidden
		}
	}

	var pinProtectionInfoBinder: Binder<PinProtectionInformation> {
		Binder(self) { base, info in
			base.infoMessageLabel.text = info.message
			base.confirmButton.isEnabled = !info.isInCoolDown
			base.cancelButton.isEnabled = !info.isInCoolDown
		}
	}
}
