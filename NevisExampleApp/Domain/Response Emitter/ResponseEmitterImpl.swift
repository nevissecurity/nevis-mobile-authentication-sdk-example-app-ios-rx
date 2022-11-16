//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import RxSwift

/// Default implementation of ``ResponseEmitter`` protocol.
class ResponseEmitterImpl: ResponseEmitter {

	// MARK: - Properties

	/// An observer that will emit an ``OperationResponse`` object  or an error in case of failed operation.
	var subject = PublishSubject<OperationResponse>()
}
