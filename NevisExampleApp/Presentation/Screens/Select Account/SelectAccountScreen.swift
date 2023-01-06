//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication
import RxCocoa
import RxSwift
import UIKit

/// The Account Selection view. Shows the list of available accounts.
final class SelectAccountScreen: BaseScreen, Screen {

	// MARK: - UI

	/// The title label.
	private let titleLabel = NSLabel(text: L10n.AccountSelection.title, style: .title)

	/// The table view.
	private let tableView = UITableView(frame: .zero, style: .grouped)

	// MARK: - Properties

	/// The view model.
	var viewModel: SelectAccountViewModel!

	/// Observable sequence used to emit the selected account.
	private let accountSubject = PublishSubject<any Account>()

	/// Thread safe bag that disposes added disposables.
	private let disposeBag = DisposeBag()

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameter viewModel: The view model.
	init(viewModel: SelectAccountViewModel) {
		self.viewModel = viewModel
		super.init()
	}

	/// :nodoc:
	deinit {
		os_log("SelectAccountScreen", log: OSLog.deinit, type: .debug)
	}
}

// MARK: - Lifecycle

extension SelectAccountScreen {

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
private extension SelectAccountScreen {

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
			$0.register(cellType: AccountCell.self)
			$0.isScrollEnabled = false
			$0.backgroundColor = .clear
			$0.rowHeight = UITableView.automaticDimension
		}

		Observable.zip(tableView.rx.modelSelected((any Account).self),
		               tableView.rx.itemSelected)
			.bind { [weak self] account, indexPath in
				self?.tableView.deselectRow(at: indexPath, animated: true)
				self?.accountSubject.on(.next(account))
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
private extension SelectAccountScreen {

	func bindViewModel() {
		assert(viewModel != nil)
		let loadTrigger = rx.viewWillAppear
			.take(1)
			.mapToVoid()
			.asDriverOnErrorJustComplete()
		let input = SelectAccountViewModel.Input(loadTrigger: loadTrigger,
		                                         selectAccount: accountSubject.asDriverOnErrorJustComplete())
		let output = viewModel.transform(input: input)
		[output.accounts.drive(tableView.rx.items) { tableView, index, account in
			tableView.dequeueReusableCell(for: IndexPath(row: index, section: 0),
			                              cellType: AccountCell.self)
		 	.then {
		 		$0.bind(viewModel: SelectAccountItemViewModel(account: account))
		 	}
		 },
		 output.selection.drive(),
		 output.loading.drive(rx.isLoading),
		 output.error.drive(rx.error)]
			.forEach { $0.disposed(by: disposeBag) }
	}
}
