//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import UIKit

extension UIApplication {
	/// Open the system settings (aka Settings app).
	///
	/// - Parameter handler: The closure to execute with the results. Default value is *nil*.
	func openSystemSettings(completion handler: ((Bool) -> ())? = nil) {
		open(URL(string: UIApplication.openSettingsURLString)!, completionHandler: handler)
	}
}
