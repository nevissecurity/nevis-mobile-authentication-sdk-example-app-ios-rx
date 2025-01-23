//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import UIKit

/// Default implementation of ``AppCoordinator`` protocol.
final class AppCoordinatorImpl {

	// MARK: - Properties

	/// The window of the application.
	private let window: UIWindow

	/// The root navigation controller.
	private var rootNavigationController: UINavigationController?

	// MARK: - Initialization

	/// Creates a new instance.
	init() {
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
		logger.app("Starting application coordinator.")
		navigateToHome()
	}

	func navigateToHome() {
		rootNavigationController?.dismiss(animated: true, completion: nil) // e.g. error

		if let screenInStack = rootNavigationController?.screenInStackFor(screenType: HomeScreen.self) {
			logger.app("Navigating to Home.")
			rootNavigationController?.popToRootViewController(animated: false)
			rootNavigationController?.setViewControllers([screenInStack], animated: true)
			return
		}

		guard let screen = DependencyProvider.shared.container.resolve(HomeScreen.self) else {
			return
		}

		logger.app("Navigating to Home.")
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

			logger.app("Navigating to Qr Scanner screen.")
			rootNavigationController?.pushViewController(screen, animated: true)
		#endif
	}

	func navigateToChangeDeviceInformation(with parameter: ChangeDeviceInformationParameter) {
		guard let screen = DependencyProvider.shared.container.resolve(ChangeDeviceInformationScreen.self,
		                                                               argument: parameter as NavigationParameterizable) else {
			return
		}

		logger.app("Navigating to Change Device Information screen.")
		rootNavigationController?.pushViewController(screen, animated: true)
	}

	func navigateToAuthCloudApiRegistration() {
		guard let screen = DependencyProvider.shared.container.resolve(AuthCloudApiRegistrationScreen.self) else {
			return
		}

		logger.app("Navigating to Auth Cloud Api Registration screen.")
		rootNavigationController?.pushViewController(screen, animated: true)
	}

	func navigateToUsernamePasswordLogin() {
		guard let screen = DependencyProvider.shared.container.resolve(UsernamePasswordLoginScreen.self) else {
			return
		}

		logger.app("Navigating to Username Password Login screen.")
		rootNavigationController?.pushViewController(screen, animated: true)
	}

	func navigateToAccountSelection(with parameter: SelectAccountParameter) {
		guard let screen = DependencyProvider.shared.container.resolve(SelectAccountScreen.self,
		                                                               argument: parameter as NavigationParameterizable) else {
			return
		}

		logger.app("Navigating to Account Selection screen.")
		rootNavigationController?.pushViewController(screen, animated: true)
	}

	func navigateToAuthenticatorSelection(with parameter: SelectAuthenticatorParameter) {
		guard let screen = DependencyProvider.shared.container.resolve(SelectAuthenticatorScreen.self,
		                                                               argument: parameter as NavigationParameterizable) else {
			return
		}

		logger.app("Navigating to Authenticator Selection screen.")
		rootNavigationController?.pushViewController(screen, animated: true)
	}

	func navigateToCredential(with parameter: CredentialParameter) {
		guard let screen = DependencyProvider.shared.container.resolve(CredentialScreen.self,
		                                                               argument: parameter as NavigationParameterizable) else {
			return
		}

		if let credentialScreen = topScreen as? CredentialScreen {
			// the `PinEnrollerImpl`, `PinUserVerifierImpl`, `PasswordEnrollerImpl` or `PasswordUserVerifierImpl` emitted a response again
			// `ResponseObserver` navigates to the Credential screen although that is the visible screen.
			// It means that the user entered an invalid credential and a recoverable error recevied.
			// Just refresh the screen with the new view model.
			credentialScreen.viewModel = DependencyProvider.shared.container.resolve(CredentialViewModel.self,
			                                                                         argument: parameter as NavigationParameterizable)
			logger.app("Refreshing Credential screen.")
			credentialScreen.refresh()
			return
		}

		logger.app("Navigating to Pin screen.")
		rootNavigationController?.pushViewController(screen, animated: true)
	}

	func navigateToTransactionConfirmation(with parameter: TransactionConfirmationParameter) {
		guard let screen = DependencyProvider.shared.container.resolve(TransactionConfirmationScreen.self,
		                                                               argument: parameter as NavigationParameterizable) else {
			return
		}

		logger.app("Navigating to Transaction Confirmation screen.")
		rootNavigationController?.pushViewController(screen, animated: true)
	}

	func navigateToConfirmation(with parameter: ConfirmationParameter) {
		guard let screen = DependencyProvider.shared.container.resolve(ConfirmationScreen.self,
		                                                               argument: parameter as NavigationParameterizable) else {
			return
		}

		logger.app("Navigating to Confirmation screen.")
		rootNavigationController?.pushViewController(screen, animated: true)
	}

	func navigateToResult(with parameter: ResultParameter) {
		guard let screen = DependencyProvider.shared.container.resolve(ResultScreen.self,
		                                                               argument: parameter as NavigationParameterizable) else {
			return
		}

		logger.app("Navigating to Result screen.")
		rootNavigationController?.pushViewController(screen, animated: true)
	}

	func present(_ controller: UIAlertController) {
		rootNavigationController?.present(controller, animated: true)
	}
}
