//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication
import RxSwift
import UIKit

/// The Home view. Starting view of the application if at least one registered authenticators can be found.
final class HomeScreen: BaseScreen, Screen {

	// MARK: - UI

	/// The title label.
	private let titleLabel = NSLabel(text: L10n.Home.title, style: .title)

	/// The description label.
	private let descriptionLabel = NSLabel(style: .normal)

	/// The Read Qr Code button.
	private let readQrCodeButton = OutlinedButton(title: L10n.Home.readQrCode)

	/// The Authenticate button.
	private let authenticateButton = OutlinedButton(title: L10n.Home.authenticate)

	/// The Deregister button.
	private let deregisterButton = OutlinedButton(title: L10n.Home.deregister)

	/// The PIN Change button.
	private let pinChangeButton = OutlinedButton(title: L10n.Home.changePin)

	/// The Change Device Information button.
	private let changeDeviceInformationButton = OutlinedButton(title: L10n.Home.changeDeviceInformation)

	/// The Auth Cloud Api Register button.
	private let authCloudApiRegisterButton = OutlinedButton(title: L10n.Home.authCloudApiRegistration)

	/// The separator label.
	private let separatorLabel = NSLabel(text: L10n.Home.separator, style: .normal)

	/// The in-Band Register button.
	private let inBandRegisterButton = OutlinedButton(title: L10n.Home.inBandRegistration)

	// MARK: - Properties

	/// The view model.
	var viewModel: HomeViewModel!

	/// Thread safe bag that disposes added disposables.
	private var disposeBag = DisposeBag()

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameter viewModel: The view model.
	init(viewModel: HomeViewModel) {
		self.viewModel = viewModel
		super.init()
	}

	/// :nodoc:
	deinit {
		os_log("HomeScreen", log: OSLog.deinit, type: .debug)
	}
}

// MARK: - Lifecycle

extension HomeScreen {

	/// Override of the `viewDidLoad()` lifecycle method. Sets up the user interface.
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
	}

	/// Override of the `viewWillAppear(_:)` lifecycle method. Binds the view model.
	///
	/// - parameter animated: If *true*, the view is being added to the window using an animation.
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		disposeBag = DisposeBag()
		bindViewModel()
	}

	func refresh() {
		// do nothing
	}
}

// MARK: - Setups

/// :nodoc:
private extension HomeScreen {

	func setupUI() {
		setupTitleLabel()
		setupDescriptionLabel()
		setupReadQrCodeButton()
		setupAuthenticateButton()
		setupDeregisterButton()
		setupPinChangeButton()
		setupChangeDeviceInformationButton()
		setupAuthCloudApiRegisterButton()
		setupSeparatorLabel()
		setupInBandRegisterButton()
	}

	func setupTitleLabel() {
		titleLabel.do {
			addItemToTop($0, topSpacing: 30)
		}
	}

	func setupDescriptionLabel() {
		descriptionLabel.do {
			addItem($0, topSpacing: 30)
		}
	}

	func setupReadQrCodeButton() {
		readQrCodeButton.do {
			addItemToBottom($0, spacing: 16)
			$0.setHeight(with: 40)
		}
	}

	func setupAuthenticateButton() {
		authenticateButton.do {
			addItemToBottom($0, spacing: 16)
			$0.setHeight(with: 40)
		}
	}

	func setupDeregisterButton() {
		deregisterButton.do {
			addItemToBottom($0, spacing: 16)
			$0.setHeight(with: 40)
		}
	}

	func setupPinChangeButton() {
		pinChangeButton.do {
			addItemToBottom($0, spacing: 16)
			$0.setHeight(with: 40)
		}
	}

	func setupChangeDeviceInformationButton() {
		changeDeviceInformationButton.do {
			addItemToBottom($0, spacing: 16)
			$0.setHeight(with: 40)
		}
	}

	func setupAuthCloudApiRegisterButton() {
		authCloudApiRegisterButton.do {
			addItemToBottom($0, spacing: 16)
			$0.setHeight(with: 40)
		}
	}

	func setupSeparatorLabel() {
		separatorLabel.do {
			addItemToBottom($0, spacing: 8)
		}
	}

	func setupInBandRegisterButton() {
		inBandRegisterButton.do {
			addItemToBottom($0, spacing: 16)
			$0.setHeight(with: 40)
		}
	}
}

// MARK: - Binding

/// :nodoc:
private extension HomeScreen {

	func bindViewModel() {
		assert(viewModel != nil)
		let loadTrigger = rx.viewDidAppear
			.take(1)
			.mapToVoid()
			.asDriverOnErrorJustComplete()
		let input = HomeViewModel.Input(loadTrigger: loadTrigger,
		                                readQrCodeTrigger: readQrCodeButton.rx.tap.asDriver(),
		                                authenticateTrigger: authenticateButton.rx.tap.asDriver(),
		                                deregisterTrigger: deregisterButton.rx.tap.asDriver(),
		                                pinChangeTrigger: pinChangeButton.rx.tap.asDriver(),
		                                changeDeviceInformationTrigger: changeDeviceInformationButton.rx.tap.asDriver(),
		                                authCloudApiRegistrationTrigger: authCloudApiRegisterButton.rx.tap.asDriver(),
		                                inBandRegistrationTrigger: inBandRegisterButton.rx.tap.asDriver())
		let output = viewModel.transform(input: input)
		[output.initClient.drive(),
		 output.accounts.drive(accountsBinder),
		 output.readQrCode.drive(),
		 output.authenticate.drive(),
		 output.deregister.drive(),
		 output.pinChange.drive(),
		 output.changeDeviceInformation.drive(),
		 output.authCloudApiRegistration.drive(),
		 output.inBandRegistration.drive(),
		 output.loading.drive(rx.isLoading),
		 output.error.drive(rx.error)]
			.forEach { $0.disposed(by: disposeBag) }
	}

	var accountsBinder: Binder<[any Account]> {
		Binder(self) { base, accounts in
			base.descriptionLabel.text = L10n.Home.description(accounts.count)
		}
	}
}
