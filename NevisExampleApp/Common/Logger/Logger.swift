//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2025. Nevis Security AG. All rights reserved.
//

import Foundation
import os
import os.log
import RxRelay
import RxSwift
import UIKit

/// Class for logging purposes. Wraps `os_log` using custom categories.
class Logger {
	/// Observable sequence that is used to emit the log.
	private var logSubject = ReplaySubject<NSAttributedString>.createUnbounded()

	/// Date formatter used during logging.
	private var dateFormatter: DateFormatter {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "HH:mm:ss"
		return dateFormatter
	}

	/// Creates an `Observable` sequence for the log messages.
	///
	/// - Returns: an `Observable` sequence for the log messages.
	func asObservable() -> Observable<NSAttributedString> {
		logSubject.asObservable()
	}

	/// Logs using `app` category type.
	/// Besides logging sends a notification with name `log` with the formatted message.
	///
	/// - Parameters:
	///   - message: The message need to be logged.
	///   - color: The color of the message. Default value is `purple`.
	///   - type: The log level. Default value is `debug`.
	///   - args: Arguments that need to be resolved in the message.
	func app(_ message: StaticString, _ color: UIColor = .purple, _ type: OSLogType = .debug, _ args: CVarArg...) {
		log(message, log: get(.app), type: type, args)
		notify(message: message, color: color, args: args)
	}

	/// Logs using `deinit` category type.
	///
	/// - Parameters:
	///   - message: The message need to be logged.
	///   - type: The log level. Default value is `debug`.
	///   - args: Arguments that need to be resolved in the message.
	func `deinit`(_ message: StaticString, _ type: OSLogType = .debug, _ args: CVarArg...) {
		log(message, log: get(.deinit), type: type, args)
	}

	/// Logs using `sdk` category type.
	/// Besides logging emits the formatted message that can be observed by the ``asObservable()`` method.
	///
	/// - Parameters:
	///   - message: The message need to be logged.
	///   - color: The color of the message. Default value is `black`.
	///   - type: The log level. Default value is `debug`.
	///   - args: Arguments that need to be resolved in the message.
	func sdk(_ message: StaticString, _ color: UIColor = .black, _ type: OSLogType = .debug, _ args: CVarArg...) {
		log(message, log: get(.sdk), type: type, args)
		notify(message: message, color: color, args: args)
	}
}

// MARK: - Local Notification

private extension Logger {
	func notify(message: StaticString, color: UIColor, args: CVarArg...) {
		let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: color]
		let attributedMessage = NSAttributedString(string: String(format: "\(message)", args),
		                                           attributes: attributes)
		let logMessage = NSMutableAttributedString(attributedString: NSAttributedString(string: "["))
		logMessage.append(NSAttributedString(string: dateFormatter.string(from: Date())))
		logMessage.append(NSAttributedString(string: "] "))
		logMessage.append(attributedMessage)
		logMessage.append(NSAttributedString(string: "\n"))
		logSubject.onNext(logMessage)
	}
}

// MARK: - Private Logger extension

private extension Logger {
	struct Category: RawRepresentable {
		var rawValue: String

		init?(rawValue: String) {
			self.rawValue = rawValue
		}
	}

	func get(_ category: Category) -> OSLog {
		OSLog(subsystem: Bundle.main.bundleIdentifier!, category: category.rawValue)
	}

	func log(_ message: StaticString, log: OSLog, type: OSLogType, _ args: CVarArg...) {
		switch args.count {
		case 0: os_log(message, log: log, type: type)
		case 1: os_log(message, log: log, type: type, args[0])
		case 2: os_log(message, log: log, type: type, args[0], args[1])
		case 3: os_log(message, log: log, type: type, args[0], args[1], args[2])
		case 4: os_log(message, log: log, type: type, args[0], args[1], args[2], args[3])
		case 5: os_log(message, log: log, type: type, args[0], args[1], args[2], args[3], args[4])
		case 6: os_log(message, log: log, type: type, args[0], args[1], args[2], args[3], args[4], args[5])
		case 7...: os_log(message, log: log, type: type, args[0], args[1], args[2], args[3], args[4], args[5], Array(args.dropFirst(6)))
		default: os_log(message, log: log, type: type, args)
		}
	}
}

// MARK: - Logger Categories

extension Logger.Category {
	static let app = Logger.Category(rawValue: "app")!
	static let `deinit` = Logger.Category(rawValue: "deinit")!
	static let sdk = Logger.Category(rawValue: "sdk")!
}

/// The logger used in the application.
let logger = Logger()
