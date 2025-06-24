//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import UIKit

/// The available label styles.
enum Style {
	/// Title label style.
	case title

	/// Normal label style.
	case normal

	/// Detail label style.
	case detail

	/// Information label style.
	case info

	/// Error label style.
	case error

	// MARK: - Properties

	/// The font based on the current style.
	var font: UIFont? {
		switch self {
		case .title: UIFont(name: "HelveticaNeue-Bold", size: 22)
		case .normal: UIFont(name: "HelveticaNeue", size: 17)
		case .detail: UIFont(name: "HelveticaNeue-Light", size: 14)
		case .info, .error: UIFont(name: "HelveticaNeue", size: 12)
		}
	}

	/// The text color based on the current style.
	var textColor: UIColor {
		switch self {
		case .detail: .lightGray
		case .error: .red
		default: .black
		}
	}

	/// The text alignment based on the current style.
	var textAlignment: NSTextAlignment {
		switch self {
		case .title: .center
		default: .left
		}
	}
}
