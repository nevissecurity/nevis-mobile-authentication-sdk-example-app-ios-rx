//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import RxSwift
import UIKit

/// Protocol describing SDK events related logging operations.
protocol SDKLogger {

	/// Converts `self` to a string`Observable` sequence.
	///
	/// - Returns: Observable sequence that represents `self`.
	func asObservable() -> Observable<NSAttributedString>

	/// Logs a message.
	///
	/// - Parameter message: The message need to be log.
	func log(_ message: String)

	/// Logs a message.
	///
	/// - Parameters:
	///   - message: The message need to be log.
	///   - color: The color need to be applied.
	func log(_ message: String, color: UIColor)
}
