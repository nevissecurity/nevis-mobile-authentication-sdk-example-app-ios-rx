//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import UIKit

/// Custom ``UIButton`` implementation with black title and black rouded border.
class OutlinedButton: UIButton {

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
