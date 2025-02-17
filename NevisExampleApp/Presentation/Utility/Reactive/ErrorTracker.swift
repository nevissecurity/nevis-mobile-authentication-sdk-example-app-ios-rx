//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import RxCocoa
import RxSwift

/// Enables monitoring errors of sequence computation.
final class ErrorTracker {

	public typealias SharingStrategy = DriverSharingStrategy

	// MARK: - Properties

	private let subject = PublishSubject<Error>()

	// MARK: - Initialization

	/// Creates a new instance.
	init() {}

	deinit {
		subject.onCompleted()
	}
}

// MARK: - SharedSequenceConvertibleType

extension ErrorTracker: SharedSequenceConvertibleType {

	func asSharedSequence() -> SharedSequence<SharingStrategy, Error> {
		subject.asObservable().asDriverOnErrorJustComplete()
	}

	func asObservable() -> Observable<Error> {
		subject.asObservable()
	}
}

// MARK: - ObservableConvertibleType

extension ObservableConvertibleType {

	func trackError(_ errorTracker: ErrorTracker) -> Observable<Element> {
		errorTracker.trackError(from: self)
	}
}

// MARK: - Private Interface

private extension ErrorTracker {

	func onError(_ error: Error) {
		subject.onNext(error)
	}

	func trackError<O: ObservableConvertibleType>(from source: O) -> Observable<O.Element> {
		source.asObservable().do(onError: onError)
	}
}
