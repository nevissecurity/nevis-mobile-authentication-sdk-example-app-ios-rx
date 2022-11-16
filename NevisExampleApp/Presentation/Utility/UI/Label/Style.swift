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
		case .title: return UIFont(name: "HelveticaNeue-Bold", size: 22)
		case .normal: return UIFont(name: "HelveticaNeue", size: 17)
		case .detail: return UIFont(name: "HelveticaNeue-Light", size: 14)
		case .info, .error: return UIFont(name: "HelveticaNeue", size: 12)
		}
	}

	/// The text color based on the current style.
	var textColor: UIColor {
		switch self {
		case .detail: return .lightGray
		case .info: return .blue
		case .error: return .red
		default: return .black
		}
	}

	/// The text alignment based on the current style.
	var textAlignment: NSTextAlignment {
		switch self {
		case .title: return .center
		default: return .left
		}
	}
}
