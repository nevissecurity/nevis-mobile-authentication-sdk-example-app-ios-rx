//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import RxSwift
import UIKit

/// The Logging view. Displays SDK related logging events.
final class LoggingScreen: UIViewController, Screen {

	// MARK: - UI

	/// The separator.
	private let separator = UIView(frame: .zero)

	/// The title label.
	private let titleLabel = NSLabel(text: L10n.Logging.title, style: .normal)

	/// The text view displaying the logs.
	private let logView = UITextView(frame: .zero)

	// MARK: - Properties

	/// The view model.
	var viewModel: LoggingViewModel!

	/// Thread safe bag that disposes added disposables.
	private let disposeBag = DisposeBag()

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameter viewModel: The view model.
	init(viewModel: LoggingViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}

	@available(*, unavailable)
	required init?(coder _: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	deinit {
		logger.deinit("LoggingScreen")
	}
}

// MARK: - Lifecycle

extension LoggingScreen {

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

private extension LoggingScreen {

	func setupUI() {
		setupSeperator()
		setupTitleLabel()
		setupLogView()
	}

	func setupSeperator() {
		separator.do {
			view.addSubview($0)
			$0.anchorToTop(0)
			$0.anchorToLeft()
			$0.anchorToRight()
			$0.setHeight(with: 2)
			$0.backgroundColor = .black
		}
	}

	func setupTitleLabel() {
		titleLabel.do {
			view.addSubview($0)
			$0.anchorToTop(10, toSafeLayout: true)
			$0.anchorToLeft(10)
			$0.anchorToRight(10)
		}
	}

	func setupLogView() {
		logView.do {
			view.addSubview($0)
			$0.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16).isActive = true
			$0.anchorToLeft(10)
			$0.anchorToRight(10)
			$0.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).do {
				$0.priority = .defaultLow
				$0.isActive = true
			}
		}
	}
}

// MARK: - Binding

private extension LoggingScreen {

	func bindViewModel() {
		assert(viewModel != nil)
		let input = LoggingViewModel.Input()
		let output = viewModel.transform(input: input)
		[output.logs.drive(logMessageBinder)]
			.forEach { $0.disposed(by: disposeBag) }
	}

	var logMessageBinder: Binder<NSAttributedString> {
		Binder(self) { base, message in
			let attributedText = NSMutableAttributedString(attributedString: base.logView.attributedText)
			attributedText.append(NSAttributedString(attributedString: message))
			base.logView.attributedText = attributedText
		}
	}
}
