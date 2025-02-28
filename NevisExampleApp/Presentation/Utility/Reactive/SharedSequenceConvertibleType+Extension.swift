//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import RxCocoa

extension SharedSequenceConvertibleType {

	/// Maps shared sequence to `Void`.
	///
	/// - Returns: A `Void` shared sequence.
	func mapToVoid() -> SharedSequence<SharingStrategy, ()> {
		map { _ in }
	}
}

extension SharedSequenceConvertibleType where Element == Bool {

	/// Combines multiple `Bool` shared sequences and performs logical `OR` operator.
	///
	/// - Parameter sources: List of `Bool` shared sequences.
	/// - Returns: A `Bool` shared sequence that will emit `true` only if at least one combined sequence emit `true`.
	static func or(_ sources: SharedSequence<DriverSharingStrategy, Bool>...) -> SharedSequence<DriverSharingStrategy, Bool> {
		Driver.combineLatest(sources)
			.map { $0.contains(true) }
	}

	/// Combines multiple `Bool` shared sequences and performs logical `AND` operator.
	///
	/// - Parameter sources: List of `Bool` shared sequences.
	/// - Returns: A `Bool` shared sequence that will emit `true` only if all combined sequence emit `true`.
	static func and(_ sources: SharedSequence<DriverSharingStrategy, Bool>...) -> SharedSequence<DriverSharingStrategy, Bool> {
		Driver.combineLatest(sources)
			.map { $0.allSatisfy(\.self) }
	}
}

extension SharedSequenceConvertibleType where Self.SharingStrategy == DriverSharingStrategy {

	/// Takes a sequence of optional elements and returns a sequence of non-optional elements, filtering out any nil values.
	///
	/// - Returns: An observable sequence of non-optional elements.
	func unwrap<T>() -> Driver<T> where Element == T? {
		filter { $0 != nil }.map { $0! }
	}
}
