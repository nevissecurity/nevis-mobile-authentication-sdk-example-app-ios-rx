//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import RxCocoa
import RxSwift

extension ObservableType {

	/// Converts observable sequence to `Driver` trait and ignores error.
	///
	/// - Returns: The built `Driver`.
	func asDriverOnErrorJustComplete() -> Driver<Element> {
		asDriver { _ in
			Driver.empty()
		}
	}

	/// Maps observable sequence to `Void`.
	///
	/// - Returns: A `Void` observable sequence.
	func mapToVoid() -> Observable<()> {
		map { _ in }
	}

	/// Takes a sequence of optional elements and returns a sequence of non-optional elements, filtering out any nil values.
	///
	/// - Returns: An observable sequence of non-optional elements.
	func unwrap<T>() -> Observable<T> where Element == T? {
		return filter { $0 != nil }.map { $0! }
	}
}
