//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication
import RxCocoa
import RxSwift
import UIKit

/// The Authenticator Selection view. Shows the list of available authenticators.
final class SelectAuthenticatorScreen: BaseScreen, Screen {

	// MARK: - UI

	/// The title label.
	private let titleLabel = NSLabel(text: L10n.AuthenticatorSelection.title, style: .title)

	/// The table view.
	private let tableView = UITableView(frame: .zero, style: .grouped)

	// MARK: - Properties

	/// The view model.
	var viewModel: SelectAuthenticatorViewModel!

	/// Observable sequence used to emit the selected authenticator.
	private let authenticatorSubject = PublishSubject<Authenticator>()

	/// Thread safe bag that disposes added disposables.
	private let disposeBag = DisposeBag()

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameter viewModel: The view model.
	init(viewModel: SelectAuthenticatorViewModel) {
		self.viewModel = viewModel
		super.init()
	}

	/// :nodoc:
	deinit {
		os_log("SelectAuthenticatorScreen", log: OSLog.deinit, type: .debug)
	}
}

// MARK: - Lifecycle

extension SelectAuthenticatorScreen {

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
private extension SelectAuthenticatorScreen {

	func setupUI() {
		setupTitleLabel()
		setupTableView()
	}

	func setupTitleLabel() {
		titleLabel.do {
			addItemToTop($0, topSpacing: 32)
		}
	}

	func setupTableView() {
		tableView.do {
			addItem($0, topSpacing: 10)
			$0.register(cellType: AuthenticatorCell.self)
			$0.isScrollEnabled = false
			$0.backgroundColor = .clear
			$0.rowHeight = UITableView.automaticDimension
		}

		Observable.zip(tableView.rx.modelSelected(Authenticator.self),
		               tableView.rx.itemSelected)
			.bind { [weak self] authenticator, indexPath in
				self?.tableView.deselectRow(at: indexPath, animated: true)
				self?.authenticatorSubject.on(.next(authenticator))
			}
			.disposed(by: disposeBag)

		let heightConstraint = tableView.heightAnchor.constraint(equalToConstant: 10000)
		heightConstraint.isActive = true
		tableView.rx.methodInvoked(#selector(UITableView.reloadData))
			.subscribe(onNext: { [unowned self] _ in
				DispatchQueue.main.async {
					self.tableView.layoutIfNeeded()
					heightConstraint.constant = self.tableView.contentSize.height
				}
			})
			.disposed(by: disposeBag)
	}
}

// MARK: - Binding

/// :nodoc:
private extension SelectAuthenticatorScreen {

	func bindViewModel() {
		assert(viewModel != nil)
		let loadTrigger = rx.viewWillAppear
			.take(1)
			.mapToVoid()
			.asDriverOnErrorJustComplete()
		let input = SelectAuthenticatorViewModel.Input(loadTrigger: loadTrigger,
		                                               selectAuthenticator: authenticatorSubject.asDriverOnErrorJustComplete())
		let output = viewModel.transform(input: input)
		[output.authenticators.drive(tableView.rx.items) { tableView, index, authenticator in
			tableView.dequeueReusableCell(for: IndexPath(row: index, section: 0),
			                              cellType: AuthenticatorCell.self)
				.then {
					$0.bind(viewModel: SelectAuthenticatorItemViewModel(authenticator: authenticator))
				}
		},
		output.selection.drive()]
			.forEach { $0.disposed(by: disposeBag) }
	}
}
