# Nevis Mobile Authentication SDK iOS Example App (RxSwift)

## Project Overview

A native iOS (Swift, UIKit) example app that shows how to integrate the Nevis Mobile Authentication SDK, a FIDO UAF 1.1 based SDK for passwordless authentication, **using RxSwift**. It is meant as a learning resource and a source of integration code for customer apps. It is not a production-ready app.

Flows demonstrated:

- Client initialization (`MobileAuthenticationClientInitializer`)
- Registration
  - in-app with Authentication Cloud (`authCloudApiRegistration`, using an enrollment response or an `appLinkUri`)
  - in-app with an Identity Suite backend (`registration` with a `CookieAuthorizationProvider` after a username/password login)
  - out-of-band through a QR code, a deep link or pending operations
- Authentication: in-band, out-of-band (QR code / deep link), and transaction confirmation
- Deregistration of one account or all accounts, and deleting local authenticators
- Changing the PIN and the password
- Changing device information
- Fetching pending out-of-band operations
- Reading local data and `MetaData` (SDK version, facet ID)

Paradigm: MVVM with a **coordinator** (`AppCoordinator`) on top of a **use case layer**, wired up with Swinject. The SDK itself has a callback-based Swift API:

- Every SDK operation is wrapped in a use case that returns an RxSwift `Observable` (`Observable.create { … }`).
- ViewModels implement `ScreenViewModel.transform(input:) -> Output`, with RxCocoa `Driver`s as inputs and outputs.
- SDK interaction callbacks (selectors, enrollers, verifiers) push `OperationResponse`s into a shared `PublishSubject` (`ResponseEmitter`). `ResponseObserver` turns these responses into navigation.

For a callback/delegate-style example without RxSwift, see the [plain iOS example](https://github.com/nevissecurity/nevis-mobile-authentication-sdk-example-app-ios).

The example covers only part of the SDK. For features that are not shown here, use the documentation at https://docs.nevis.net/mobilesdk. Don't infer SDK behavior from memory.

## SDK & Related Resources

How the SDK is consumed:

- **CocoaPods**, see `Podfile`. There are two pods, linked per build configuration:
  - `NevisMobileAuthentication-Debug` (`~> 4.6.0`) for the `Debug` configuration. This is the **debug flavor**: it runs on devices and simulators, has logging, and only a subset of the protection mechanisms.
  - `NevisMobileAuthentication` (`~> 4.6.0`) for the `Release` configuration. This is the **release flavor**: all protection mechanisms are on, and it **runs on physical devices only**.
- The SDK is also published as a Swift package: https://github.com/nevissecurity/nevis-mobile-authentication-sdk-ios-package. **CocoaPods support for the SDK ends when the CocoaPods Specs repository becomes read-only at the end of 2026.** For a new customer app, recommend Swift Package Manager. SPM can't link per configuration, so a release target and a debug target are needed (see the installation guide).
- See the [iOS installation guide](https://docs.nevis.net/mobilesdk/guide/installation/ios-installation) and [SDK flavors](https://docs.nevis.net/mobilesdk/guide/introduction#sdk-flavors).

Documentation (https://docs.nevis.net):

- [Quickstart: build the example and use it](https://docs.nevis.net/mobilesdk/quickstart)
- [Requirements](https://docs.nevis.net/mobilesdk/guide/requirements)
- [Configuration](https://docs.nevis.net/mobilesdk/guide/configuration) (Authentication Cloud, Identity Suite, custom backend, facet ID)
- [Initialization](https://docs.nevis.net/mobilesdk/guide/initialization)
- Operations: [registration](https://docs.nevis.net/mobilesdk/guide/operation/registration), [authentication](https://docs.nevis.net/mobilesdk/guide/operation/authentication), [deregistration](https://docs.nevis.net/mobilesdk/guide/operation/deregistration), [other operations](https://docs.nevis.net/mobilesdk/guide/operation/other-operations)
- [Error handling](https://docs.nevis.net/mobilesdk/guide/error-handling), [best practices](https://docs.nevis.net/mobilesdk/guide/best-practices), [troubleshooting](https://docs.nevis.net/mobilesdk/appendixes/troubleshooting)
- Integration scenarios: [Authentication Cloud](https://docs.nevis.net/mobilesdk/integration-scenarios/authentication-cloud), [Identity Suite](https://docs.nevis.net/mobilesdk/integration-scenarios/identity-suite)
- [Push support](https://docs.nevis.net/mobilesdk/guide/push_support) (not implemented in this example)
- [Swift API reference (DocC)](https://docs.nevis.net/mobilesdk/api-references/swift/documentation/nevismobileauthentication/), [all API references](https://docs.nevis.net/mobilesdk/reference/api-references)
- [iOS release notes](https://docs.nevis.net/mobilesdk/release_notes/ios-release-notes)
- [Authentication Cloud documentation](https://docs.nevis.net/authcloud/)

Example apps on other platforms (same feature set, useful for comparison):

- iOS, callback style: https://github.com/nevissecurity/nevis-mobile-authentication-sdk-example-app-ios
- Android: https://github.com/nevissecurity/nevis-mobile-authentication-sdk-example-app-android
- Android, Kotlin Coroutines: https://github.com/nevissecurity/nevis-mobile-authentication-sdk-example-app-android-coroutines
- Flutter: https://github.com/nevissecurity/nevis-mobile-authentication-sdk-example-app-flutter
- React Native: https://github.com/nevissecurity/nevis-mobile-authentication-sdk-example-app-react

## Prerequisites & Configuration

Backend: either a **Nevis Authentication Cloud** instance (with an access key to start enrollments), or an **Identity Suite** setup (nevisFIDO behind nevisProxy/nevisAuth). See `README.md` § "Getting Started".

All configuration is **build-time only**. To point the app at your own environment:

1. **Pick the environment.** In `NevisExampleApp/Application/Dependency Provider/AppAssembly.swift`, change the `ConfigurationLoaderImpl(environment: .authenticationCloud)` registration to `.identitySuite` if needed. The environment selects which plist gets loaded (`Common/Configuration/Model/Environment.swift`).
2. **Backend settings.** These live in `NevisExampleApp/Resources/`:
   - `ConfigAuthenticationCloud.plist`: replace `myinstance.mauth.nevis.cloud` in `sdk.hostName` (and in `login.loginRequestURL`).
   - `ConfigIdentitySuite.plist`: set `sdk.baseUrl` and, if your setup differs from the defaults, the endpoint paths (`registrationRequestPath`, `authenticationRequestPath`, …), timeouts and retries. Also set `login.loginRequestURL`.
   - Both files contain `authenticatorAllowlist`, the AAIDs that may be offered: `F1D0#1001` PIN, `#1002` Touch ID, `#1003` Face ID, `#1004` device passcode, `#1005` password.
   - The plist is decoded in `Common/Configuration/Model/AppConfiguration.swift`. If `sdk.hostName` is present, the app uses `Configuration(authCloudHostname:)`; otherwise it decodes a full `Configuration`. See [Configuration](https://docs.nevis.net/mobilesdk/guide/configuration).
3. **Identity Suite login (in-app registration only).** `Data/Data Source/LoginDataSourceImpl.swift` posts to `loginRequestURL` with nevisAuth form fields (`isiwebuserid` / `isiwebpasswd`, see `Data/Model/LoginRequest.swift`). The cookies it receives become a `CookieAuthorizationProvider`. Adapt this to your login flow.
4. **Deep links.** In `NevisExampleApp/Resources/Info.plist`, change the `nevisaccess` custom URL scheme (`CFBundleURLTypes` → `CFBundleURLSchemes`) to your scheme.
   - `SceneDelegate` forwards incoming URLs. `DeepLink.build(with:)` only accepts URLs that carry a `dispatchTokenResponse` query parameter, and `DeepLinkHandlerImpl` decodes them and starts the out-of-band operation.
   - Universal Links are not set up in this example. For them, add the Associated Domains capability and an `apple-app-site-association` file on your domain.
5. **Bundle ID and facet ID.** The bundle ID is `ch.nevis.mobile.authentication.sdk.ios.example` (target build settings). The iOS facet ID is `ios:bundle-id:<bundle id>`, and the backend must list it, or operations fail with an untrusted facet ID error. After changing the bundle ID, update the backend facet list too. See [Facet ID](https://docs.nevis.net/mobilesdk/guide/configuration#facet-id).
6. **Signing.** `DEVELOPMENT_TEAM` is empty, and signing is automatic. Set your own team to run on a device.

## Build & Run Commands

`README.md` has the full setup. Quick reference:

```bash
pod install                       # install dependencies; always open NevisExampleApp.xcworkspace, not the .xcodeproj
open NevisExampleApp.xcworkspace  # then run the NevisExampleApp scheme (Debug) on a simulator or device

# Command-line build check (no signing):
xcodebuild -workspace NevisExampleApp.xcworkspace -scheme NevisExampleApp \
  -configuration Debug -destination 'generic/platform=iOS Simulator' build
```

Requirements: Xcode 26.2 or later and CocoaPods. The deployment target is iOS 14.0. A SwiftFormat build phase reformats sources on every build if `swiftformat` is installed; the rules are in `.swiftformat` (tabs, Swift 6 syntax). The repo has no unit or UI test targets; to verify changes, run the app against a backend.

## Architecture

### Source layout (`NevisExampleApp/`)

```
Application/
  AppDelegate, SceneDelegate     app entry, URL handling
  App Loader/                    AppLoader: bootstraps DI, coordinator, ResponseObserver
  Dependency Provider/           AppAssembly (Swinject registrations: config, use cases, interactions, screens), DependencyProvider
  Deep Link/                     DeepLinkHandlerImpl: dispatchTokenResponse → decode → out-of-band operation
Common/
  Configuration/                 ConfigurationLoader(+Impl), AppConfiguration, Environment, LoginConfiguration
  Coordinator/, Deep Link/, Error/ (ErrorHandlerChain, NevisErrorHandler), Extensions/, Logger/
Data/                            Identity Suite login: LoginDataSourceImpl, LoginRepositoryImpl, request/response models (demo only)
Domain/
  Client Provider/               ClientProvider(+Impl): holds the initialized MobileAuthenticationClient
  Use Case/                      One use case per SDK operation: execute(...) -> Observable<…>
  Interaction/                   SDK callback implementations: AccountSelector, AuthenticatorSelector,
                                 Biometric/DevicePasscode user verifiers, Pin/ and Password/ enrollers, verifiers, changers
  Response Emitter/              ResponseEmitter(+Impl): shared PublishSubject<OperationResponse>
  Model/                         OperationResponse subtypes (SelectAuthenticatorResponse, EnrollPinResponse, CompletedResponse, …), errors
  Validators/                    AuthenticatorValidator, AccountValidator, PasswordPolicyImpl
Presentation/
  Coordinator/App/               AppCoordinator(+Impl): all navigation
  Screens/<Name>/                <Name>Screen (UIViewController) + <Name>ViewModel (ScreenViewModel: Input → Output)
  Utility/Response Observer/     ResponseObserver(+Impl): OperationResponse → coordinator navigation
  Utility/Reactive/              ActivityIndicator, ErrorTracker, Driver/Observable helpers
  Utility/…                      UI components, validation (JWT / Auth Cloud enrollment), localization
Resources/                       Info.plist, Config*.plist, assets
```

### How SDK callbacks become Rx streams

1. A ViewModel's `transform(input:)` maps a trigger (`Driver<()>`) to a use case, for example `InBandAuthenticationUseCaseImpl.execute(username:operation:)`. It uses `trackActivity` / `trackError` for the loading and error state.
2. The use case starts the SDK operation inside `Observable.create`, with the interaction objects that Swinject injects. `onSuccess` emits a `CompletedResponse` and completes; `onError` emits an `OperationError`.
3. When the SDK needs user input, an interaction implementation (for example `AuthenticatorSelectorImpl`, `PinEnrollerImpl`) wraps the SDK context and **handler** in an `OperationResponse` and sends it to `ResponseEmitter.subject`.
4. `ResponseObserverImpl` (started at app launch) observes the subject on the main scheduler and calls the right `AppCoordinator.navigateTo…` with a parameter that carries the handler.
5. The target screen's ViewModel completes the handler with the user's input, for example `SelectAuthenticatorViewModel` → `handler.aaid(...)`, `CredentialViewModel` → `handler.pin(...)`, and then sets it to `nil`. Cancelling the screen calls `handler.cancel()`.
6. When the operation finishes, the use case's `Observable` emits, and `responseObserver.observe(response:)` navigates to the result screen.

Other details:

- **Named registrations**: there are two `AuthenticatorSelector` instances, `RegistrationAuthenticatorSelectorName` (`auth_selector_reg`) and `AuthenticationAuthenticatorSelectorName` (`auth_selector_auth`). They filter differently through `AuthenticatorValidator`.
- **Scopes**: `ClientProvider` and `ResponseEmitter` are registered with `.inObjectScope(.container)`, so they are singletons.
- **Initialization**: `HomeViewModel` loads the configuration (`ConfigurationLoader.load()`) and calls `InitClientUseCaseImpl`. If the client already exists, it is reused.
- **Environment-specific behavior**: with Identity Suite, deregistration first goes through account selection and in-band authentication, because the deregistration endpoint needs an `AuthorizationProvider`. With Authentication Cloud, deregistration is called directly (see `HomeViewModel.deregister(accounts:)`).

## Integration Guidance

When moving code into your own app:

| If you want to… | Look at | Notes |
|---|---|---|
| Add the SDK dependency | `Podfile` | Prefer SPM for new apps; see [installation](https://docs.nevis.net/mobilesdk/guide/installation/ios-installation). |
| Configure the backend | `Resources/Config*.plist`, `AppConfiguration`, `ConfigurationLoaderImpl` | Or construct `Configuration` in code; see [Configuration](https://docs.nevis.net/mobilesdk/guide/configuration). |
| Wrap SDK operations in Rx | `Domain/Use Case/` | `Observable.create` around the operation builder is reusable as is. |
| Bridge SDK callbacks to UI | `Domain/Interaction/`, `ResponseEmitter`, `ResponseObserverImpl` | Reusable pattern; replace the coordinator and screens with your own. |
| Initialize the SDK once | `InitClientUseCaseImpl`, `ClientProviderImpl` | |
| Register with Authentication Cloud | `AuthCloudApiRegistrationUseCaseImpl`, `AuthCloudApiRegistrationViewModel` | Your backend gets the enrollment response / `appLinkUri` from Authentication Cloud. |
| Register with Identity Suite | `RegistrationUseCaseImpl`, `LoginUseCaseImpl`, `UsernamePasswordLoginViewModel` | Replace the login call with your own; keep the `AuthorizationProvider` idea. |
| Handle QR codes / deep links | `DecodePayloadUseCaseImpl`, `OutOfBandOperationUseCaseImpl`, `DeepLinkHandlerImpl`, `SceneDelegate` | QR scanning (`Qr Scanner/`, MercariQRScanner) is demo scaffolding. |
| Authenticate in-band | `InBandAuthenticationUseCaseImpl` | |
| Pick the authenticator | `AuthenticatorSelectorImpl`, `AuthenticatorValidatorImpl` | Reusable filtering logic; replace the UI. |
| Enroll, verify or change a PIN/password | `Domain/Interaction/Pin/`, `Password/`, `ChangePinUseCaseImpl`, `ChangePasswordUseCaseImpl`, `CredentialViewModel` | Recoverable errors and protection status (lockout/cool-down) come with the responses. |
| Face ID / Touch ID / device passcode | `BiometricUserVerifierImpl`, `DevicePasscodeUserVerifierImpl` | Customize the prompt texts. |
| Transaction confirmation | `AccountSelectorImpl`, `TransactionConfirmationViewModel` | [Transaction confirmation](https://docs.nevis.net/mobilesdk/concept/operations/transaction-confirmation) |
| Deregister / delete authenticators / device info | `DeregistrationUseCaseImpl`, `DeleteAuthenticatorsUseCaseImpl`, `ChangeDeviceInformationUseCaseImpl` | |
| Pending out-of-band operations | `FetchPendingOperationsUseCaseImpl` | |
| Push notifications | Not implemented | See [Push support](https://docs.nevis.net/mobilesdk/guide/push_support). |

Demo-only code that should not be copied as is:

- the logging screen (`Screens/Logging/`)
- showing raw technical errors to users (see [Error handling](https://docs.nevis.net/mobilesdk/guide/error-handling))
- the hard-coded login request
- the UI components and styling (`Presentation/Utility/UI/`)
- the placeholder URL scheme and host names

If something isn't covered here, check https://docs.nevis.net (guide + DocC API reference) before you write code. Don't guess the API.

## Conventions & Gotchas

- **Simulator vs. device**: the `Debug` configuration links the debug flavor, which runs on simulators. The `Release` configuration links the release flavor, which **does not run on simulators**, so Release builds need a physical device.
- **Device passcode prerequisite**: biometric and device passcode authenticators need a device passcode to be set. Face ID / Touch ID also need enrolled biometrics. On the simulator, enroll and trigger Face ID / Touch ID through *Features → Face ID / Touch ID*. See [Device lock screen](https://docs.nevis.net/mobilesdk/concept/concept-description/key-protection/device-lock-screen).
- **`NSFaceIDUsageDescription` and `NSCameraUsageDescription`** must stay in `Info.plist`. Without them, iOS terminates the app when Face ID or the QR scanner is used.
- **Minimum OS**: iOS 14.0 (`Podfile` + target build settings). The SDK doesn't support Bitcode, so the `Podfile` `post_install` disables it.
- **Handlers are single-use**: every SDK handler must be completed or cancelled exactly once. ViewModels set them to `nil` after use; keep that pattern, or the operation hangs.
- **Main thread**: don't assume that SDK callbacks arrive on the main thread. UI work is routed through `ResponseObserverImpl` (`observe(on: MainScheduler.instance)`) and `Driver`s; keep doing that when you add new flows.
- **Retain cycles**: the `Observable.create` closures capture `[weak self]` / `[unowned self]`. Follow the same pattern in new use cases.
- **SDK version alignment**: the pods use `~> 4.6.0`. Keep `Podfile` and `Podfile.lock` in sync (`pod install`), and check the [iOS release notes](https://docs.nevis.net/mobilesdk/release_notes/ios-release-notes) when upgrading.
- **Code style**: SwiftFormat (`.swiftformat`) with tab indentation. Document public types with `///` comments; DocC sources are in `Documentation.docc`.
- **New files must be added to `NevisExampleApp.xcodeproj`**, in the correct group and the `NevisExampleApp` target. A file that exists on disk but not in the project is not compiled.
- **Never commit secrets** (signing certificates, provisioning profiles, tokens) or personal Xcode state (`xcuserdata/`).
