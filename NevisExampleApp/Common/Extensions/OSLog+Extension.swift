//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import Foundation
@_exported import os
@_exported import os.log

extension OSLog {

	/// Identifier used as a subsystem for `OSLog`.
	private static var subsystem = Bundle.main.bundleIdentifier!

	/// The default log object.
	static let `default` = OSLog(subsystem: subsystem, category: "default")
	/// Log object that can be used during `deinit()` phase.
	static let `deinit` = OSLog(subsystem: subsystem, category: "deinit")
	/// SDK related log object.
	static let sdk = OSLog(subsystem: subsystem, category: "sdk_log")
}
