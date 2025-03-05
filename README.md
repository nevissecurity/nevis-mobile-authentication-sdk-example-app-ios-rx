![Nevis Logo](https://www.nevis.net/hubfs/Nevis/images/logotype.svg)

# Nevis Mobile Authentication SDK iOS Example App Reactive

[![Main Branch Commit](https://github.com/nevissecurity/nevis-mobile-authentication-sdk-example-app-ios-rx/actions/workflows/main.yml/badge.svg)](https://github.com/nevissecurity/nevis-mobile-authentication-sdk-example-app-ios-rx/actions/workflows/main.yml)
[![Verify Pull Request](https://github.com/nevissecurity/nevis-mobile-authentication-sdk-example-app-ios-rx/actions/workflows/pr.yml/badge.svg)](https://github.com/nevissecurity/nevis-mobile-authentication-sdk-example-app-ios-rx/actions/workflows/pr.yml)

This repository contains the example app demonstrating how to use the Nevis Mobile Authentication SDK in an iOS mobile application.
The Nevis Mobile Authentication SDK allows you to integrate passwordless authentication to your existing mobile app, backed by the FIDO UAF 1.1 Standard.

Some SDK features demonstrated in this example app are:

* Using the SDK with the Nevis Authentication Cloud
* Registering with QR code & app link URIs
* Simulating in-band authentication after registration
* Deregistering a registered account
* Changing the PIN of the PIN authenticator
* Changing the device information

Please note that the example app only demonstrates a subset of the available SDK features. The main purpose is to demonstrate how the SDK can be used, not to cover all supported scenarios.

## Getting Started

Before you start compiling and using the example applications please ensure you have the following ready:

* An [Authentication Cloud](https://docs.nevis.net/authcloud/) instance provided by Nevis.
* An [access key](https://docs.nevis.net/authcloud/access-app/access-key) to use with the Authentication Cloud.

Your development setup has to meet the following prerequisites:

* iOS 12 or later
* Xcode 16.2, including Swift 6.0.3

### Initialization

Dependencies in this project are provided via Cocoapods. Please install all dependencies by running

`
pod install
`

### Configuration

Before being able to use the example app with your Authentication Cloud instance, you'll need to update the configuration file with the right host information.

Edit the [ConfigAuthenticationCloud.plist](NevisExampleApp/Resources/ConfigAuthenticationCloud.plist) file and replace the host name information with your Authentication Cloud instance.

#### Configuration Change

The example apps are supporting two kinds of configuration: `authenticationCloud` and `identitySuite`.

> [!NOTE]
> Only *build-time* configuration change is supported.

To change the configuration open the [AppAssembly.swift](NevisExampleApp/Application/Dependency%20Provider/AppAssembly.swift) file which describes the dependency injection related configuration using the `Swinject` library.
The `environment` parameter should be changed when injecting the `ConfigurationLoaderImpl` component to one of the values already mentioned.

#### Handling deep links

The example applications handle deep links which contain a valid `dispatchTokenResponse` query parameter of an out-of-band operation.

The feature is achieved with Custom URL Schemes.

> [!NOTE]
> Further information: [Define custom url scheme](https://developer.apple.com/documentation/xcode/defining-a-custom-url-scheme-for-your-app).

##### Custom URL Schemes

Modify the content of `CFBundleURLSchemes` array in the [Info.plist](NevisExampleApp/Resources/Info.plist) file with the right scheme information of your environment.

```
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>nevisaccess</string>
        </array>
    </dict>
</array>
```

### Build & run

Now you're ready to build and run the example app by choosing Product > Run from Xcode's menu or by clicking the Run button in your project’s toolbar.

> [!NOTE]
> Running the app on an iOS device requires codesign setup.

### Try it out

Now that the iOS example app is up and running, it's time to try it out!

Check out our [Quickstart Guide](https://docs.nevis.net/mobilesdk/quickstart).

## Integration Notes

In this section you can find hints about how the Nevis Mobile Authentication SDK is integrated into the example app.

* All SDK invocation is implemented in a form of a [use case](NevisExampleApp/Domain/Use%20Case).
* All SDK specific user interaction related protocol implementation can be found in the [Interaction](NevisExampleApp/Domain/Interaction) folder.

### Initialization

The [InitClientUseCaseImpl](NevisExampleApp/Domain/Use%20Case/InitClientUseCaseImpl.swift) class is responsible for creating and initializing a `MobileAuthenticationClient` instance which is the entry point to the SDK. Later this instance can be used to start the different operations.

### Registration

Before being able to authenticate using the Nevis Mobile Authentication SDK, go through the registration process. Depending on the use case, there are two types of registration: [in-app registration](#in-app-registration) and [out-of-band registration](#out-of-band-registration).

#### In-app registration

If the application is using a backend using the Nevis Authentication Cloud, the [AuthCloudApiRegistrationUseCaseImpl](NevisExampleApp/Domain/Use%20Case/AuthCloudApiRegistrationUseCaseImpl.swift) class will be used by passing the `enrollment` response or an `appLinkUri`.

When the backend used by the application does not use the Nevis Authentication Cloud the name of the user to be registered is passed to the [RegistrationUseCaseImpl](NevisExampleApp/Domain/Use%20Case/RegistrationUseCaseImpl.swift) class.
If authorization is required by the backend to register, provide an `AuthorizationProvider`. In the example app a `CookieAuthorizationProvider` is created from the cookies (see [UsernamePasswordLoginViewModel](NevisExampleApp/Presentation/Screens/Username%20Password%20Login/UsernamePasswordLoginViewModel.swift)) obtained by the [LoginUseCase](NevisExampleApp/Domain/Use%20Case/LoginUseCase.swift) class.

#### Out-of-band registration

When the registration is initiated in another device or application, the information required to process the operation is transmitted through a QR code or a link. After the payload obtained from the QR code or the link is decoded the  [OutOfBandOperationUseCaseImpl](NevisExampleApp/Domain/Use%20Case/OutOfBandOperationUseCaseImpl.swift) class starts the out-of-band operation.

### Authentication

Using the authentication operation, you can verify the identity of the user using an already registered authenticator. Depending on the use case, there are two types of authentication: [in-app authentication](#in-app-authentication) and [out-of-band authentication](#out-of-band-authentication).

#### In-app authentication

For the application to trigger the authentication, the name of the user is provided to the [InBandAuthenticationUseCaseImpl](NevisExampleApp/Domain/Use%20Case/InBandAuthenticationUseCaseImpl.swift) class.

#### Out-of-band authentication

When the authentication is initiated in another device or application, the information required to process the operation is transmitted through a QR code or a link. After the payload obtained from the QR code or the link is decoded the  [OutOfBandOperationUseCaseImpl](NevisExampleApp/Domain/Use%20Case/OutOfBandOperationUseCaseImpl.swift) class starts the out-of-band operation.

#### Transaction confirmation

There are cases when specific information is to be presented to the user during the user verification process, known as transaction confirmation. The `AuthenticatorSelectionContext` and the `AccountSelectionContext` contain a byte array with the information. In the example app it is handled in the [AccountSelectorImpl](NevisExampleApp/Domain/Interaction/AccountSelectorImpl.swift) class.

### Deregistration

The [DeregistrationUseCaseImpl](NevisExampleApp/Domain/Use%20Case/DeregistrationUseCaseImpl.swift) class is responsible for deregistering either a user or all of the registered users from the device.

### Other operations

#### Change PIN

The change PIN operation is implemented in the [ChangePinUseCaseImpl](NevisExampleApp/Domain/Use%20Case/ChangePinUseCaseImpl.swift) class with which you can modify the PIN of a registered PIN authenticator for a given user.

#### Change password

The change password operation is implemented in the [ChangePasswordUseCaseImpl](NevisExampleApp/Domain/Use%20Case/ChangePasswordUseCaseImpl.swift) class with which you can modify the password of a registered Password authenticator for a given user.

#### Decode out-of-band payload

Out-of-band operations occur when a message is delivered to the application through an alternate channel like a push notification, a QR code, or a deep link. With the help of the [DecodePayloadUseCaseImpl](NevisExampleApp/Domain/Use%20Case/DecodePayloadUseCaseImpl.swift) class the application can create an `OutOfBandPayload` either from a JSON or a Base64 URL encoded String. The `OutOfBandPayload` is then used to start an `OutOfBandOperation`, see chapters [Out-of-Band Registration](#out-of-band-registration) and [Out-of-Band Authentication](#out-of-band-authentication).

#### Change device information

During registration, the device information can be provided that contains the name identifying your device, and also the Firebase Cloud Messaging registration token. Updating the device name is implemented in the [ChangeDeviceInformationUseCaseImpl](NevisExampleApp/Domain/Use%20Case/ChangeDeviceInformationUseCaseImpl.swift) class.

> [!NOTE]
> Firebase Cloud Messaging is not supported in the example app.

#### Get information

The following use cases are responsible for getting information with the help of `LocalData`:

* The [GetAccountsUseCaseImpl](NevisExampleApp/Domain/Use%20Case/GetAccountsUseCaseImpl.swift) class obtains the registered accounts.
* The [GetAuthenticatorsUseCaseImpl](NevisExampleApp/Domain/Use%20Case/GetAuthenticatorsUseCaseImpl.swift) class obtains the authenticator information.
* The [GetDeviceInformationUseCaseImpl](NevisExampleApp/Domain/Use%20Case/GetDeviceInformationUseCaseImpl.swift) class obtains the device information.

### Error handling

As this is an example app, we are directly showing the technical error occurring. Be aware that this is not to be considered best practice. Your own production app should handle the errors in a more appropriate manner such as providing translations for all your supported languages as well as simplifying the error message presented to the end-user in a way non-technical adverse people can understand and act upon them.

© 2023 made with ❤ by Nevis
