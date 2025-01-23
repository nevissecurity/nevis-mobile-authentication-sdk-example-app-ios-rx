//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import RxSwift

/// The Transaction Confirmation view.
final class TransactionConfirmationScreen: BaseScreen, Screen {

	// MARK: - UI

	/// The title label.
	private let titleLabel = NSLabel(text: L10n.TrxConfirm.title, style: .title)

	/// The description label.
	private let descriptionLabel = NSLabel(style: .normal)

	/// The confirm button.
	private let confirmButton = OutlinedButton(title: L10n.TrxConfirm.confirm)

	/// The cancel button.
	private let cancelButton = OutlinedButton(title: L10n.TrxConfirm.cancel)

	// MARK: - Properties

	/// The view model.
	var viewModel: TransactionConfirmationViewModel!

	/// Thread safe bag that disposes added disposables.
	private let disposeBag = DisposeBag()

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameter viewModel: The view model.
	init(viewModel: TransactionConfirmationViewModel) {
		self.viewModel = viewModel
		super.init()
	}

	deinit {
		logger.deinit("TransactionConfirmationScreen")
	}
}

// MARK: - Lifecycle

extension TransactionConfirmationScreen {

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

private extension TransactionConfirmationScreen {

	func setupUI() {
		setupTitleLabel()
		setupDescriptionLabel()
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

	func setupConfirmButton() {
		confirmButton.do {
			addItemToBottom($0, spacing: 16)
			$0.setHeight(with: 40)
		}
	}

	func setupCancelButton() {
		cancelButton.do {
			addItemToBottom($0, spacing: 16)
			$0.setHeight(with: 40)
		}
	}
}

// MARK: - Binding

private extension TransactionConfirmationScreen {

	func bindViewModel() {
		assert(viewModel != nil)
		let input = TransactionConfirmationViewModel.Input(confirmTrigger: confirmButton.rx.tap.asDriver(),
		                                                   cancelTrigger: cancelButton.rx.tap.asDriver())
		let output = viewModel.transform(input: input)
		[output.description.drive(descriptionLabel.rx.text),
		 output.confirm.drive(),
		 output.cancel.drive()]
			.forEach { $0.disposed(by: disposeBag) }
	}
}
