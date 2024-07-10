//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import NevisMobileAuthentication
import Swinject
import SwinjectAutoregistration

/// The application DI configuration assembly.
final class AppAssembly {}

// MARK: - Assembly

extension AppAssembly: Assembly {

	func assemble(container: Container) {
		registerScreens(container: container)
		registerCoordinators(container: container)
		registerViewModels(container: container)
		registerUseCases(container: container)
		registerRepositories(container: container)
		registerDataSources(container: container)
		registerComponents(container: container)
	}
}

// MARK: - Private Interface

private extension AppAssembly {

	// MARK: Screens

	/// Registers the screens.
	///
	/// - Parameter container: The container provided by the `Assembler`.
	func registerScreens(container: Container) {
		container.autoregister(LaunchScreen.self,
		                       initializer: LaunchScreen.init)
			.inObjectScope(.weak)

		container.autoregister(HomeScreen.self,
		                       initializer: HomeScreen.init)
			.inObjectScope(.weak)

		container.autoregister(QrScannerScreen.self,
		                       initializer: QrScannerScreen.init)
			.inObjectScope(.weak)

		container.register(ChangeDeviceInformationScreen.self) { (res: Resolver, arg: NavigationParameterizable) in
			ChangeDeviceInformationScreen(viewModel: res ~> (ChangeDeviceInformationViewModel.self,
			                                                 argument: arg))
		}.inObjectScope(.weak)

		container.autoregister(AuthCloudApiRegistrationScreen.self,
		                       initializer: AuthCloudApiRegistrationScreen.init)
			.inObjectScope(.weak)

		container.autoregister(UsernamePasswordLoginScreen.self,
		                       initializer: UsernamePasswordLoginScreen.init)
			.inObjectScope(.weak)

		container.register(SelectAccountScreen.self) { (res: Resolver, arg: NavigationParameterizable) in
			SelectAccountScreen(viewModel: res ~> (SelectAccountViewModel.self,
			                                       argument: arg))
		}.inObjectScope(.weak)

		container.register(SelectAuthenticatorScreen.self) { (res: Resolver, arg: NavigationParameterizable) in
			SelectAuthenticatorScreen(viewModel: res ~> (SelectAuthenticatorViewModel.self,
			                                             argument: arg))
		}.inObjectScope(.weak)

		container.register(CredentialScreen.self) { (res: Resolver, arg: NavigationParameterizable) in
			CredentialScreen(viewModel: res ~> (CredentialViewModel.self, argument: arg))
		}.inObjectScope(.weak)

		container.register(TransactionConfirmationScreen.self) { (res: Resolver, arg: NavigationParameterizable) in
			TransactionConfirmationScreen(viewModel: res ~> (TransactionConfirmationViewModel.self,
			                                                 argument: arg))
		}.inObjectScope(.weak)

		container.register(ConfirmationScreen.self) { (res: Resolver, arg: NavigationParameterizable) in
			ConfirmationScreen(viewModel: res ~> (ConfirmationViewModel.self,
			                                      argument: arg))
		}.inObjectScope(.weak)

		container.register(ResultScreen.self) { (res: Resolver, arg: NavigationParameterizable) in
			ResultScreen(viewModel: res ~> (ResultViewModel.self,
			                                argument: arg))
		}.inObjectScope(.weak)

		container.autoregister(LoggingScreen.self,
		                       initializer: LoggingScreen.init)
			.inObjectScope(.container)
	}

	// MARK: Coordinators

	/// Registers the coordinators.
	///
	/// - Parameter container: The container provided by the `Assembler`.
	func registerCoordinators(container: Container) {
		container.autoregister(AppCoordinator.self,
		                       initializer: AppCoordinatorImpl.init)
			.inObjectScope(.container)
	}

	// MARK: View models

	/// Registers the view models.
	///
	/// - Parameter container: The container provided by the `Assembler`.
	func registerViewModels(container: Container) {
		container.autoregister(LaunchViewModel.self,
		                       initializer: LaunchViewModel.init)
			.inObjectScope(.transient)

		container.autoregister(HomeViewModel.self,
		                       initializer: HomeViewModel.init)
			.inObjectScope(.transient)

		container.autoregister(QrScannerViewModel.self,
		                       initializer: QrScannerViewModel.init)
			.inObjectScope(.transient)

		container.autoregister(ChangeDeviceInformationViewModel.self,
		                       argument: NavigationParameterizable.self,
		                       initializer: ChangeDeviceInformationViewModel.init)
			.inObjectScope(.transient)

		container.autoregister(AuthCloudApiRegistrationViewModel.self,
		                       initializer: AuthCloudApiRegistrationViewModel.init)
			.inObjectScope(.transient)

		container.autoregister(UsernamePasswordLoginViewModel.self,
		                       initializer: UsernamePasswordLoginViewModel.init)
			.inObjectScope(.transient)

		container.autoregister(SelectAccountViewModel.self,
		                       argument: NavigationParameterizable.self,
		                       initializer: SelectAccountViewModel.init)
			.inObjectScope(.transient)

		container.autoregister(SelectAuthenticatorViewModel.self,
		                       argument: NavigationParameterizable.self,
		                       initializer: SelectAuthenticatorViewModel.init)
			.inObjectScope(.transient)

		container.autoregister(CredentialViewModel.self,
		                       argument: NavigationParameterizable.self,
		                       initializer: CredentialViewModel.init)
			.inObjectScope(.transient)

		container.autoregister(TransactionConfirmationViewModel.self,
		                       argument: NavigationParameterizable.self,
		                       initializer: TransactionConfirmationViewModel.init)
			.inObjectScope(.transient)

		container.autoregister(ConfirmationViewModel.self,
		                       argument: NavigationParameterizable.self,
		                       initializer: ConfirmationViewModel.init)
			.inObjectScope(.transient)

		container.autoregister(ResultViewModel.self,
		                       argument: NavigationParameterizable.self,
		                       initializer: ResultViewModel.init)
			.inObjectScope(.transient)

		container.autoregister(LoggingViewModel.self,
		                       initializer: LoggingViewModel.init)
			.inObjectScope(.transient)
	}

	// MARK: Use-cases

	/// Registers the use cases.
	///
	/// - Parameter container: The container provided by the `Assembler`.
	func registerUseCases(container: Container) {
		container.autoregister(InitClientUseCase.self,
		                       initializer: InitClientUseCaseImpl.init)

		container.autoregister(DecodePayloadUseCase.self,
		                       initializer: DecodePayloadUseCaseImpl.init)

		container.register(OutOfBandOperationUseCase.self) { res in
			let authSelectorForReg = res ~> (AuthenticatorSelector.self,
			                                 name: RegistrationAuthenticatorSelectorName)
			let authSelectorForAuth = res ~> (AuthenticatorSelector.self,
			                                  name: AuthenticationAuthenticatorSelectorName)
			return OutOfBandOperationUseCaseImpl(clientProvider: res~>,
			                                     createDeviceInformationUseCase: res~>,
			                                     accountSelector: res~>,
			                                     registrationAuthenticatorSelector: authSelectorForReg,
			                                     authenticationAuthenticatorSelector: authSelectorForAuth,
			                                     pinEnroller: res~>,
			                                     pinUserVerifier: res~>,
			                                     passwordEnroller: res~>,
			                                     passwordUserVerifier: res~>,
			                                     biometricUserVerifier: res~>,
			                                     devicePasscodeUserVerifier: res~>,
			                                     logger: res~>)
		}

		container.register(RegistrationUseCase.self) { res in
			let authenticatorSelector = res ~> (AuthenticatorSelector.self,
			                                    name: RegistrationAuthenticatorSelectorName)
			return RegistrationUseCaseImpl(clientProvider: res~>,
			                               createDeviceInformationUseCase: res~>,
			                               authenticatorSelector: authenticatorSelector,
			                               pinEnroller: res~>,
			                               passwordEnroller: res~>,
			                               biometricUserVerifier: res~>,
			                               devicePasscodeUserVerifier: res~>,
			                               logger: res~>)
		}

		container.register(InBandAuthenticationUseCase.self) { res in
			let authenticatorSelector = res ~> (AuthenticatorSelector.self,
			                                    name: AuthenticationAuthenticatorSelectorName)
			return InBandAuthenticationUseCaseImpl(clientProvider: res~>,
			                                       authenticatorSelector: authenticatorSelector,
			                                       pinUserVerifier: res~>,
			                                       passwordUserVerifier: res~>,
			                                       biometricUserVerifier: res~>,
			                                       devicePasscodeUserVerifier: res~>,
			                                       logger: res~>)
		}

		container.autoregister(DeregistrationUseCase.self,
		                       initializer: DeregistrationUseCaseImpl.init)

		container.autoregister(ChangePinUseCase.self,
		                       initializer: ChangePinUseCaseImpl.init)

		container.autoregister(ChangePasswordUseCase.self,
		                       initializer: ChangePasswordUseCaseImpl.init)

		container.register(AuthCloudApiRegistrationUseCase.self) { res in
			let authenticatorSelector = res ~> (AuthenticatorSelector.self,
			                                    name: RegistrationAuthenticatorSelectorName)
			return AuthCloudApiRegistrationUseCaseImpl(clientProvider: res~>,
			                                           createDeviceInformationUseCase: res~>,
			                                           authenticatorSelector: authenticatorSelector,
			                                           pinEnroller: res~>,
			                                           passwordEnroller: res~>,
			                                           biometricUserVerifier: res~>,
			                                           devicePasscodeUserVerifier: res~>,
			                                           logger: res~>)
		}

		container.autoregister(GetDeviceInformationUseCase.self,
		                       initializer: GetDeviceInformationUseCaseImpl.init)

		container.autoregister(ChangeDeviceInformationUseCase.self,
		                       initializer: ChangeDeviceInformationUseCaseImpl.init)

		container.autoregister(CreateDeviceInformationUseCase.self,
		                       initializer: CreateDeviceInformationUseCaseImpl.init)

		container.autoregister(GetAccountsUseCase.self,
		                       initializer: GetAccountsUseCaseImpl.init)

		container.autoregister(GetAuthenticatorsUseCase.self,
		                       initializer: GetAuthenticatorsUseCaseImpl.init)

		container.autoregister(DeleteAuthenticatorsUseCase.self,
		                       initializer: DeleteAuthenticatorsUseCaseImpl.init)

		container.autoregister(LoginUseCase.self,
		                       initializer: LoginUseCaseImpl.init)
	}

	// MARK: Repositories

	/// Registers the repositories.
	///
	/// - Parameter container: The container provided by the `Assembler`.
	func registerRepositories(container: Container) {
		container.autoregister(LoginRepository.self,
		                       initializer: LoginRepositoryImpl.init)
	}

	// MARK: Data sources

	/// Registers the data sources.
	///
	/// - Parameter container: The container provided by the `Assembler`.
	func registerDataSources(container: Container) {
		container.autoregister(LoginDataSource.self,
		                       initializer: LoginDataSourceImpl.init)
	}

	// MARK: Components

	/// Registers the components.
	///
	/// - Parameter container: The container provided by the `Assembler`.
	func registerComponents(container: Container) {
		container.register(ConfigurationLoader.self) { _ in
			ConfigurationLoaderImpl(environment: .authenticationCloud)
		}

		container.autoregister(ClientProvider.self,
		                       initializer: ClientProviderImpl.init)
			.inObjectScope(.container)

		container.autoregister(AccountSelector.self,
		                       initializer: AccountSelectorImpl.init)

		container.register(AuthenticatorSelector.self,
		                   name: AuthenticationAuthenticatorSelectorName) { res in
			AuthenticatorSelectorImpl(authenticatorValidator: res~>,
			                          operation: .authentication,
			                          responseEmitter: res~>,
			                          logger: res~>)
		}

		container.register(AuthenticatorSelector.self,
		                   name: RegistrationAuthenticatorSelectorName) { res in
			AuthenticatorSelectorImpl(authenticatorValidator: res~>,
			                          operation: .registration,
			                          responseEmitter: res~>,
			                          logger: res~>)
		}

		container.autoregister(PinEnroller.self,
		                       initializer: PinEnrollerImpl.init)

		container.autoregister(PinChanger.self,
		                       initializer: PinChangerImpl.init)

		container.autoregister(PinUserVerifier.self,
		                       initializer: PinUserVerifierImpl.init)

		container.autoregister(PasswordEnroller.self,
		                       initializer: PasswordEnrollerImpl.init)

		container.autoregister(PasswordChanger.self,
		                       initializer: PasswordChangerImpl.init)

		container.autoregister(PasswordUserVerifier.self,
		                       initializer: PasswordUserVerifierImpl.init)

		container.autoregister(BiometricUserVerifier.self,
		                       initializer: BiometricUserVerifierImpl.init)

		container.autoregister(DevicePasscodeUserVerifier.self,
		                       initializer: DevicePasscodeUserVerifierImpl.init)

		container.autoregister(ResponseEmitter.self,
		                       initializer: ResponseEmitterImpl.init)
			.inObjectScope(.container)

		container.autoregister(ResponseObserver.self,
		                       initializer: ResponseObserverImpl.init)
			.inObjectScope(.container)

		container.autoregister(AccountValidator.self,
		                       initializer: AccountValidatorImpl.init)

		container.autoregister(AuthenticatorValidator.self,
		                       initializer: AuthenticatorValidatorImpl.init)

		container.autoregister(SDKLogger.self,
		                       initializer: SDKLoggerImpl.init)
			.inObjectScope(.container)

		container.autoregister(DeepLinkHandler.self,
		                       initializer: DeepLinkHandlerImpl.init)
			.inObjectScope(.container)

		container.autoregister(ErrorHandler.self,
		                       name: NevisErrorHandlerName,
		                       initializer: NevisErrorHandler.init)

		container.autoregister(ErrorHandler.self,
		                       name: GeneralErrorHandlerName,
		                       initializer: GeneralErrorHandler.init)

		container.register(ErrorHandlerChain.self) { res in
			ErrorHandlerChainImpl(errorHandlers: [res ~> (ErrorHandler.self, name: NevisErrorHandlerName),
			                                      res ~> (ErrorHandler.self, name: GeneralErrorHandlerName)])
		}
	}
}
