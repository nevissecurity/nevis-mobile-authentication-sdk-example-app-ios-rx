# ``NevisExampleApp``

An example application demonstrating how to use the Nevis Mobile Authentication SDK in an iOS mobile application.

## Overview

The Nevis Mobile Authentication SDK allows you to integrate passwordless authentication to your existing mobile app, backed by the FIDO UAF 1.1 Standard.

Some SDK features demonstrated in this example app are:

* Using the SDK with the Nevis Authentication Cloud
* Registering with QR code & app link URIs
* Simulating in-band authentication after registration
* Deregistering a registered account
* Changing the PIN of the PIN authenticator
* Changing the device information

Please note that the example app only demonstrates a subset of the available SDK features. The main purpose is to demonstrate how the SDK can be used, not to cover all supported scenarios.

## Topics

### Application

- ``AppDelegate``
- ``AppLoader``

### Configuration

- ``ConfigurationLoader``
- ``ConfigurationLoaderImpl``
- ``LoginConfiguration``
- ``AppConfiguration``
- ``Environment``

### Coordinator

- ``Coordinator``
- ``NavigationParameterizable``
- ``AppCoordinator``
- ``AppCoordinatorImpl``

### Dependency Provider

- ``DependencyProvider``
- ``AppAssembly``

### Error

- ``AppError``
- ``ErrorHandlerChain``
- ``ErrorHandlerChainImpl``
- ``ErrorHandler``
- ``GeneralErrorHandlerName``
- ``GeneralErrorHandler``
- ``NevisErrorHandlerName``
- ``NevisErrorHandler``

### DeepLink

- ``DeepLink``
- ``DeepLinkHandler``
- ``DeepLinkHandlerImpl``

### Screens

- ``Screen``
- ``ScreenViewModel``
- ``BaseScreen``
- ``LaunchScreen``
- ``LaunchViewModel``
- ``HomeScreen``
- ``HomeViewModel``
- ``QrScannerScreen``
- ``QrScannerViewModel``
- ``SelectAccountScreen``
- ``SelectAccountViewModel``
- ``SelectAccountParameter``
- ``SelectAccountItemViewModel``
- ``AccountCell``
- ``SelectAuthenticatorScreen``
- ``SelectAuthenticatorViewModel``
- ``SelectAuthenticatorParameter``
- ``SelectAuthenticatorItemViewModel``
- ``AuthenticatorCell``
- ``CredentialScreen``
- ``CredentialViewModel``
- ``CredentialParameter``
- ``PinParameter``
- ``PasswordParameter``
- ``CredentialProtectionInformation``
- ``AuthCloudApiRegistrationScreen``
- ``AuthCloudApiRegistrationViewModel``
- ``ChangeDeviceInformationScreen``
- ``ChangeDeviceInformationViewModel``
- ``ChangeDeviceInformationParameter``
- ``UsernamePasswordLoginScreen``
- ``UsernamePasswordLoginViewModel``
- ``TransactionConfirmationScreen``
- ``TransactionConfirmationViewModel``
- ``TransactionConfirmationParameter``
- ``ConfirmationScreen``
- ``ConfirmationViewModel``
- ``ConfirmationParameter``
- ``ResultScreen``
- ``ResultViewModel``
- ``ResultParameter``
- ``LoggingScreen``
- ``LoggingViewModel``

### UI

- ``Style``
- ``NSLabel``
- ``NSTextField``
- ``OutlinedButton``

### Countdown Timer

- ``InteractionCountDownTimer``


### Reactive Components

- ``ActivityIndicator``
- ``ErrorTracker``

### Response Observer

- ``ResponseObserver``
- ``ResponseObserverImpl``

### UI Validation

- ``AuthCloudApiRegistrationValidator``
- ``JWTValidator``
- ``ValidationError``
- ``ValidationResult``

### Localization

- ``L10n``

### Logger

- ``Logger-class``
- ``logger``

### Interaction & Validation

- ``PinChangerImpl``
- ``PinEnrollerImpl``
- ``PasswordChangerImpl``
- ``PasswordEnrollerImpl``
- ``PasswordPolicyImpl``
- ``AccountSelectorImpl``
- ``AuthenticatorSelectorImpl``
- ``AuthenticationAuthenticatorSelectorName``
- ``RegistrationAuthenticatorSelectorName``
- ``PinUserVerifierImpl``
- ``PasswordUserVerifierImpl``
- ``BiometricUserVerifierImpl``
- ``DevicePasscodeUserVerifierImpl``
- ``AccountValidator``
- ``AccountValidatorImpl``
- ``AuthenticatorValidator``
- ``AuthenticatorValidatorImpl``
- ``PasswordPolicyError``

### Domain Model

- ``AuthenticatorItem``
- ``Operation``
- ``OperationError``
- ``BusinessError``
- ``Credentials``
- ``OperationResponse``
- ``ChangePinResponse``
- ``ChangePasswordResponse``
- ``CompletedResponse``
- ``ConfirmTransactionResponse``
- ``EnrollPinResponse``
- ``EnrollPasswordResponse``
- ``SelectAccountResponse``
- ``SelectAuthenticatorResponse``
- ``VerifyPinResponse``
- ``VerifyPasswordResponse``
- ``VerifyBiometricResponse``
- ``VerifyDevicePasscodeResponse``

### Domain Repository

- ``LoginRepository``

### Domain Use Case

- ``AuthCloudApiRegistrationUseCase``
- ``AuthCloudApiRegistrationUseCaseImpl``
- ``ChangeDeviceInformationUseCase``
- ``ChangeDeviceInformationUseCaseImpl``
- ``ChangePinUseCase``
- ``ChangePinUseCaseImpl``
- ``ChangePasswordUseCase``
- ``ChangePasswordUseCaseImpl``
- ``CreateDeviceInformationUseCase``
- ``CreateDeviceInformationUseCaseImpl``
- ``DecodePayloadUseCase``
- ``DecodePayloadUseCaseImpl``
- ``DeregistrationUseCase``
- ``DeregistrationUseCaseImpl``
- ``GetAccountsUseCase``
- ``GetAccountsUseCaseImpl``
- ``GetAuthenticatorsUseCase``
- ``GetAuthenticatorsUseCaseImpl``
- ``GetDeviceInformationUseCase``
- ``GetDeviceInformationUseCaseImpl``
- ``InBandAuthenticationUseCase``
- ``InBandAuthenticationUseCaseImpl``
- ``InitClientUseCase``
- ``InitClientUseCaseImpl``
- ``LoginUseCase``
- ``LoginUseCaseImpl``
- ``OutOfBandOperationUseCase``
- ``OutOfBandOperationUseCaseImpl``
- ``RegistrationUseCase``
- ``RegistrationUseCaseImpl``
- ``DeleteAuthenticatorsUseCase``
- ``DeleteAuthenticatorsUseCaseImpl``

### Client Provider

- ``ClientProvider``
- ``ClientProviderImpl``

### Domain Response Emitter

- ``ResponseEmitter``
- ``ResponseEmitterImpl``

### Data Model

- ``LoginRequest``
- ``LoginResponse``

### Data Repository

- ``LoginRepositoryImpl``

### Data Source

- ``LoginDataSource``
- ``LoginDataSourceImpl``
- ``LoginSessionDelegate``
