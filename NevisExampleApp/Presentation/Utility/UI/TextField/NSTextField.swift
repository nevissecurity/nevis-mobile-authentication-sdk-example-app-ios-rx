//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import UIKit

/// Custom ``UITextField`` implementation.
class NSTextField: UITextField {

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameters:
	///   - placeholder: The placeholder to display. Default value is an empty string.
	///   - returnKeyType: The return key type. Default value is `done`.
	init(placeholder: String = "",
	     returnKeyType: UIReturnKeyType = .done) {
		super.init(frame: .zero)
		self.text = nil
		self.placeholder = placeholder
		self.returnKeyType = returnKeyType
		borderStyle = .roundedRect
	}

	@available(*, unavailable)
	required init?(coder _: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
