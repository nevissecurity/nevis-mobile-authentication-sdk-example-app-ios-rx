//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import UIKit

extension UINavigationController {

	/// Returns a view controller from the stack by type.
	///
	/// - Parameter screenType: The type of the screen.
	/// - Returns: The view controller if found, `nil` otherwise.
	func screenInStackFor<T: UIViewController>(screenType _: T.Type) -> T? where T: Screen {
		viewControllers.first(where: { $0 is T }) as? T
	}
}
