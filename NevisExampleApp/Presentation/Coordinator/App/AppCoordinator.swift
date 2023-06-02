//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import UIKit

/// Describes application related navigation operations.
protocol AppCoordinator: Coordinator {

	/// The top most screen in the view stack.
	var topScreen: BaseScreen? { get }

	/// Navigates to the Home screen.
	func navigateToHome()

	/// Navigates to the Qr Scanner screen.
	func navigateToQrScanner()

	/// Navigates to the Change Device Information screen.
	///
	/// - Parameter parameter: The navigation parameter.
	func navigateToChangeDeviceInformation(with parameter: ChangeDeviceInformationParameter)

	/// Navigates to the Auth Cloud Api Registration screen.
	func navigateToAuthCloudApiRegistration()

	/// Navigates to the Username Password Login screen.
	func navigateToUsernamePasswordLogin()

	/// Navigates to the Account Selection screen.
	///
	/// - Parameter parameter: The navigation parameter.
	func navigateToAccountSelection(with parameter: SelectAccountParameter)

	/// Navigates to the Authenticator Selection screen.
	///
	/// - Parameter parameter: The navigation parameter.
	func navigateToAuthenticatorSelection(with parameter: SelectAuthenticatorParameter)

	/// Navigates to the Pin screen.
	///
	/// - Parameter parameter: The navigation parameter.
	func navigateToPin(with parameter: PinParameter)

	/// Navigates to the Transaction Confirmation screen.
	///
	/// - Parameter parameter: The navigation parameter.
	func navigateToTransactionConfirmation(with parameter: TransactionConfirmationParameter)

	/// Navigates to the Result screen.
	///
	/// - Parameter parameter: The navigation parameter.
	func navigateToResult(with parameter: ResultParameter)

	/// Presents an alert controller.
	///
	/// - Parameter controller: The alert controller that need to be presented.
	func present(_ controller: UIAlertController)
}
