//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import UIKit

/// Default implementation of ``AppCoordinator`` protocol.
final class AppCoordinatorImpl {

	// MARK: - Properties

	/// The logger.
	private let logger: SDKLogger

	/// The window of the application.
	private let window: UIWindow

	/// The root navigation controller.
	private var rootNavigationController: UINavigationController?

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameter logger: The logger.
	init(logger: SDKLogger) {
		self.logger = logger
		self.window = UIWindow()

		guard let rootViewController = DependencyProvider.shared.container.resolve(LaunchScreen.self) else {
			return
		}

		self.rootNavigationController = UINavigationController(rootViewController: rootViewController)
		rootNavigationController?.isNavigationBarHidden = true
		window.rootViewController = rootNavigationController
		window.makeKeyAndVisible()
	}
}

// MARK: - AppCoordinator

extension AppCoordinatorImpl: AppCoordinator {

	var topScreen: BaseScreen? {
		rootNavigationController?.topViewController as? BaseScreen
	}

	func start() {
		logger.log("Starting application coordinator.", color: .purple)
		navigateToHome()
	}

	func navigateToHome() {
		rootNavigationController?.dismiss(animated: true, completion: nil) // e.g. error

		if let screenInStack = rootNavigationController?.screenInStackFor(screenType: HomeScreen.self) {
			logger.log("Navigating to Home.", color: .purple)
			rootNavigationController?.popToRootViewController(animated: false)
			rootNavigationController?.setViewControllers([screenInStack], animated: true)
			return
		}

		guard let screen = DependencyProvider.shared.container.resolve(HomeScreen.self) else {
			return
		}

		logger.log("Navigating to Home.", color: .purple)
		rootNavigationController?.popToRootViewController(animated: false)
		rootNavigationController?.setViewControllers([screen], animated: true)
	}

	func navigateToQrScanner() {
		#if targetEnvironment(simulator)
			let alert = UIAlertController(title: L10n.Error.App.QrCodeScan.title,
			                              message: L10n.Error.App.QrCodeScan.Unavailable.message,
			                              preferredStyle: .alert)
			alert.addAction(.init(title: L10n.Error.App.QrCodeScan.confirm,
			                      style: .default))
			present(alert)
		#else
			guard let screen = DependencyProvider.shared.container.resolve(QrScannerScreen.self) else {
				return
			}

			logger.log("Navigating to Qr Scanner screen.", color: .purple)
			rootNavigationController?.pushViewController(screen, animated: true)
		#endif
	}

	func navigateToChangeDeviceInformation(with parameter: ChangeDeviceInformationParameter) {
		guard let screen = DependencyProvider.shared.container.resolve(ChangeDeviceInformationScreen.self,
		                                                               argument: parameter as NavigationParameterizable) else {
			return
		}

		logger.log("Navigating to Change Device Information screen.", color: .purple)
		rootNavigationController?.pushViewController(screen, animated: true)
	}

	func navigateToAuthCloudApiRegistration() {
		guard let screen = DependencyProvider.shared.container.resolve(AuthCloudApiRegistrationScreen.self) else {
			return
		}

		logger.log("Navigating to Auth Cloud Api Registration screen.", color: .purple)
		rootNavigationController?.pushViewController(screen, animated: true)
	}

	func navigateToLegacyLogin() {
		guard let screen = DependencyProvider.shared.container.resolve(LegacyLoginScreen.self) else {
			return
		}

		logger.log("Navigating to Legacy Login screen.", color: .purple)
		rootNavigationController?.pushViewController(screen, animated: true)
	}

	func navigateToAccountSelection(with parameter: SelectAccountParameter) {
		guard let screen = DependencyProvider.shared.container.resolve(SelectAccountScreen.self,
		                                                               argument: parameter as NavigationParameterizable) else {
			return
		}

		logger.log("Navigating to Account Selection screen.", color: .purple)
		rootNavigationController?.pushViewController(screen, animated: true)
	}

	func navigateToAuthenticatorSelection(with parameter: SelectAuthenticatorParameter) {
		guard let screen = DependencyProvider.shared.container.resolve(SelectAuthenticatorScreen.self,
		                                                               argument: parameter as NavigationParameterizable) else {
			return
		}

		logger.log("Navigating to Authenticator Selection screen.", color: .purple)
		rootNavigationController?.pushViewController(screen, animated: true)
	}

	func navigateToPin(with parameter: PinParameter) {
		guard let screen = DependencyProvider.shared.container.resolve(PinScreen.self,
		                                                               argument: parameter as NavigationParameterizable) else {
			return
		}

		if let pinScreen = topScreen as? PinScreen {
			// the `PinEnrollerImpl` or `PinUserVerifierImpl` emitted a response again
			// `ResponseObserver` navigates to the PIN screen although that is the visible screen
			// It means that the user entered an invalid PIN and a recoverable error recevied
			// Just refresh the screen with the new view model
			pinScreen.viewModel = DependencyProvider.shared.container.resolve(PinViewModel.self,
			                                                                  argument: parameter as NavigationParameterizable)
			logger.log("Refreshing Pin screen.", color: .purple)
			pinScreen.refresh()
			return
		}

		logger.log("Navigating to Pin screen.", color: .purple)
		rootNavigationController?.pushViewController(screen, animated: true)
	}

	func navigateToTransactionConfirmation(with parameter: TransactionConfirmationParameter) {
		guard let screen = DependencyProvider.shared.container.resolve(TransactionConfirmationScreen.self,
		                                                               argument: parameter as NavigationParameterizable) else {
			return
		}

		logger.log("Navigating to Transaction Confirmation screen.", color: .purple)
		rootNavigationController?.pushViewController(screen, animated: true)
	}

	func navigateToNotEnrolledAuthenticator() {
		guard let screen = DependencyProvider.shared.container.resolve(NotEnrolledAuthenticatorScreen.self) else {
			return
		}

		logger.log("Navigating to Not Enrolled Authenticator screen.", color: .purple)
		rootNavigationController?.pushViewController(screen, animated: true)
	}

	func navigateToResult(with parameter: ResultParameter) {
		guard let screen = DependencyProvider.shared.container.resolve(ResultScreen.self,
		                                                               argument: parameter as NavigationParameterizable) else {
			return
		}

		logger.log("Navigating to Result screen.", color: .purple)
		rootNavigationController?.pushViewController(screen, animated: true)
	}

	func present(_ controller: UIAlertController) {
		rootNavigationController?.present(controller, animated: true)
	}
}
