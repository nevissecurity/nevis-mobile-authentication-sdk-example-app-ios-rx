//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import UIKit

/// Custom ``UIButton`` implementation with black title and black rouded border.
class OutlinedButton: UIButton {

	// MARK: - Properties

	/// A Boolean value indicating whether the control is in the enabled state.
	override var isEnabled: Bool {
		didSet {
			backgroundColor = isEnabled ? .clear : #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
		}
	}

	/// A Boolean value indicating whether the control draws a highlight.
	override var isHighlighted: Bool {
		didSet {
			backgroundColor = isHighlighted ? #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1) : .clear
		}
	}

	/// A Boolean value indicating whether the control is in the selected state.
	override var isSelected: Bool {
		didSet {
			backgroundColor = isHighlighted ? #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1) : .clear
		}
	}

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameter title: The title to display. Default value is `nil`.
	init(title: String? = nil) {
		super.init(frame: .zero)
		setTitleColor(.black, for: .normal)
		setTitle(title, for: .normal)
		layer.borderColor = UIColor.black.cgColor
		layer.borderWidth = 2.0
		layer.cornerRadius = 10.0
	}

	@available(*, unavailable)
	required init?(coder _: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
