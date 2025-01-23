//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import RxCocoa
import RxSwift

private struct ActivityToken<E>: ObservableConvertibleType, Disposable {

	// MARK: - Properties

	private let source: Observable<E>
	private let disposeBag: Cancelable

	// MARK: - Initialization

	init(source: Observable<E>, disposeAction: @escaping () -> ()) {
		self.source = source
		self.disposeBag = Disposables.create(with: disposeAction)
	}

	// MARK: - Public Interface

	func dispose() {
		disposeBag.dispose()
	}

	func asObservable() -> Observable<E> {
		source
	}
}

/// Enables monitoring of sequence computation.
///
/// If there is at least one sequence computation in progress, `true` will be sent.
/// When all activities complete `false` will be sent.
final class ActivityIndicator {

	public typealias Element = Bool
	public typealias SharingStrategy = DriverSharingStrategy

	// MARK: - Properties

	private let lock = NSRecursiveLock()
	private let relay = BehaviorRelay(value: 0)
	private let loading: SharedSequence<SharingStrategy, Bool>

	// MARK: - Initialization

	/// Creates a new instance.
	init() {
		self.loading = relay.asDriver()
			.map { $0 > 0 }
			.distinctUntilChanged()
	}
}

// MARK: - SharedSequenceConvertibleType

extension ActivityIndicator: SharedSequenceConvertibleType {

	func asSharedSequence() -> SharedSequence<SharingStrategy, Element> {
		loading
	}
}

// MARK: - ObservableConvertibleType

extension ObservableConvertibleType {

	func trackActivity(_ activityIndicator: ActivityIndicator) -> Observable<Element> {
		activityIndicator.trackActivityOfObservable(self)
	}
}

// MARK: - Private Interface

private extension ActivityIndicator {

	func trackActivityOfObservable<Source: ObservableConvertibleType>(_ source: Source) -> Observable<Source.Element> {
		Observable.using({ () -> ActivityToken<Source.Element> in
			self.increment()
			return ActivityToken(source: source.asObservable(), disposeAction: self.decrement)
		}) { t in
			t.asObservable()
		}
	}

	func increment() {
		lock.lock()
		relay.accept(relay.value + 1)
		lock.unlock()
	}

	func decrement() {
		lock.lock()
		relay.accept(relay.value - 1)
		lock.unlock()
	}
}
