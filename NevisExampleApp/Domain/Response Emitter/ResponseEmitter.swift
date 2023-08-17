//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import RxSwift

/// Protocol declaration for emitting operation responses from the Domain layer.
///
/// Used by the different Nevis specific user interaction related implementations.
/// In the Presentation layer it can be observed and the necessary actions, navigations can be performed.
///
/// - See: ``PinChangerImpl``
/// - See: ``PinEnrollerImpl``
/// - See: ``AccountSelectorImpl``
/// - See: ``AuthenticationAuthenticatorSelectorImpl``
/// - See: ``RegistrationAuthenticatorSelectorImpl``
/// - See: ``PinUserVerifierImpl``
protocol ResponseEmitter {

	/// An observable that will emit an ``OperationResponse`` object or an error in case of failed operation.
	var subject: PublishSubject<OperationResponse> { get }
}
