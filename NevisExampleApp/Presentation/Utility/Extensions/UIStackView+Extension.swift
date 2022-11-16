//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import UIKit

extension UIStackView {

	/// Adds an item to `self`.
	///
	/// - Parameters:
	///   - item: The item that need to be added.
	///   - spacing: The bottom spacing. Default value is 0.
	///   - leftSpacing: The left spacing. Default value is 0.
	///   - rightSpacing: The right spacing. Default value is 0.
	///   - topSpacing: The top spacing. Default value is 0.
	func addItem(_ item: UIView,
	             spacing: CGFloat = 0.0,
	             leftSpacing: CGFloat = 0.0,
	             rightSpacing: CGFloat = 0.0,
	             topSpacing: CGFloat = 0.0) {
		let containerView = UIView()
		containerView.addSubview(item)

		item.anchorToSuperView(topPadding: topSpacing,
		                       bottomPadding: spacing,
		                       leftPadding: leftSpacing,
		                       rightPadding: rightSpacing)

		addArrangedSubview(containerView)
	}

	/// Adds an item to the center of `self`.
	///
	/// - Parameters:
	///   - item: The item that need to be added.
	///   - spacing: The spacing. Default value is 0.
	func addItemCentered(_ item: UIView,
	                     spacing: CGFloat = 0) {
		let containerView = UIView()
		containerView.addSubview(item)

		item.anchorToTop(spacing)
		item.anchorToBottom(spacing)
		item.anchorToMiddle()

		addArrangedSubview(containerView)
	}
}
