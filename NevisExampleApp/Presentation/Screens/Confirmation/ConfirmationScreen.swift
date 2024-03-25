//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2024 Nevis Security AG. All rights reserved.
//

import RxSwift

/// The Confirmation view.
final class ConfirmationScreen: BaseScreen, Screen {

	// MARK: - UI

	/// The content view.
	private let contentView = UIStackView(frame: .zero)

	/// The title label.
	private let titleLabel = NSLabel(style: .title)

	/// The confirm button.
	private let confirmButton = OutlinedButton(title: L10n.Confirmation.confirm)

	/// The cancel button.
	private let cancelButton = OutlinedButton(title: L10n.Confirmation.cancel)

	// MARK: - Properties

	/// The view model.
	var viewModel: ConfirmationViewModel!

	/// Thread safe bag that disposes added disposables.
	private let disposeBag = DisposeBag()

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameter viewModel: The view model.
	init(viewModel: ConfirmationViewModel) {
		self.viewModel = viewModel
		super.init()
	}

	/// :nodoc:
	deinit {
		os_log("ConfirmationScreen", log: OSLog.deinit, type: .debug)
	}
}

// MARK: - Lifecycle

extension ConfirmationScreen {

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
private extension ConfirmationScreen {

	func setupUI() {
		setupContentView()
		setupTitleLabel()
		setupConfirmButton()
		setupCancelButton()
	}

	func setupContentView() {
		contentView.do {
			view.addSubview($0)
			$0.anchorToMiddle()
			$0.anchorToLeft(16)
			$0.anchorToRight(16)
			$0.spacing = 16
			$0.axis = .vertical
		}
	}

	func setupTitleLabel() {
		titleLabel.do {
			contentView.addArrangedSubview($0)
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

/// :nodoc:
private extension ConfirmationScreen {

	func bindViewModel() {
		assert(viewModel != nil)
		let input = ConfirmationViewModel.Input(confirmTrigger: confirmButton.rx.tap.asDriver(),
		                                        cancelTrigger: cancelButton.rx.tap.asDriver())
		let output = viewModel.transform(input: input)
		[output.title.drive(titleLabel.rx.text),
		 output.confirm.drive(),
		 output.cancel.drive()]
			.forEach { $0.disposed(by: disposeBag) }
	}
}
