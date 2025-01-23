//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import UIKit

/// Custom `UILabel` implementation.
class NSLabel: UILabel {

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameters:
	///   - text: The text to display. Default value is an empty string.
	///   - style: The style of the label.
	///   - textAlignment: The text aligment. Default value is `nil`.
	init(text: String = "",
	     style: Style,
	     textAlignment: NSTextAlignment? = nil) {
		super.init(frame: .zero)
		self.text = text
		font = style.font
		textColor = style.textColor
		self.textAlignment = textAlignment ?? style.textAlignment
		numberOfLines = 0
	}

	@available(*, unavailable)
	required init?(coder _: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
