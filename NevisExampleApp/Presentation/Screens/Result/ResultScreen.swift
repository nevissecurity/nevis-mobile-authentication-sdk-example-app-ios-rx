//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import RxSwift
import UIKit

/// The Result view.
final class ResultScreen: BaseScreen, Screen {

	// MARK: - UI

	/// The content view.
	private let contentView = UIStackView(frame: .zero)

	/// The title label.
	private let titleLabel = NSLabel(style: .title)

	/// The description label.
	private let descriptionLabel = NSLabel(style: .normal, textAlignment: .center)

	/// The action button.
	private let actionButton = OutlinedButton(title: L10n.Result.continue)

	// MARK: - Properties

	/// The view model.
	var viewModel: ResultViewModel!

	/// Thread safe bag that disposes added disposables.
	private let disposeBag = DisposeBag()

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameter viewModel: The view model.
	init(viewModel: ResultViewModel) {
		self.viewModel = viewModel
		super.init()
	}

	/// :nodoc:
	deinit {
		os_log("ResultScreen", log: OSLog.deinit, type: .debug)
	}
}

// MARK: - Lifecycle

extension ResultScreen {

	/// Override of the `viewDidLoad()` lifecycle method. Sets up the user interface and binds the view model.
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
private extension ResultScreen {

	func setupUI() {
		setupContentView()
		setupTitleLabel()
		setupDescriptionLabel()
		setupActionButton()
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

	func setupDescriptionLabel() {
		descriptionLabel.do {
			contentView.addArrangedSubview($0)
		}
	}

	func setupActionButton() {
		actionButton.do {
			addItemToBottom($0, spacing: 16)
			$0.setHeight(with: 40)
		}
	}
}

// MARK: - Binding

/// :nodoc:
private extension ResultScreen {

	func bindViewModel() {
		assert(viewModel != nil)
		let input = ResultViewModel.Input(actionTrigger: actionButton.rx.tap.asDriver())
		let output = viewModel.transform(input: input)
		[output.title.drive(titleLabel.rx.text),
		 output.description.drive(descriptionLabel.rx.text),
		 output.action.drive()]
			.forEach { $0.disposed(by: disposeBag) }
	}
}
