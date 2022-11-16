//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import UIKit

extension UIView {

	/// Anchors `self` to super view.
	///
	/// - Parameters:
	///   - topPadding: The top padding. Default value is 0.
	///   - bottomPadding: The bottom padding. Default value is 0.
	///   - leftPadding: The left padding. Default value is 0.
	///   - rightPadding: The right padding. Default value is 0.
	///   - toSafeLayout: Tells whether anchoring to safe layout is needed. Default value is false.
	/// - Returns: `self`
	@discardableResult
	func anchorToSuperView(topPadding: CGFloat = 0.0,
	                       bottomPadding: CGFloat = 0.0,
	                       leftPadding: CGFloat = 0.0,
	                       rightPadding: CGFloat = 0.0,
	                       toSafeLayout: Bool = false) -> UIView {
		anchorToTop(topPadding, toSafeLayout: toSafeLayout)
		anchorToBottom(bottomPadding, toSafeLayout: toSafeLayout)
		anchorToLeft(leftPadding)
		anchorToRight(rightPadding)
		return self
	}

	/// Anchors `self` to the center of super view along the X axis.
	///
	/// - Returns: `self`
	@discardableResult
	func anchorToMiddleX() -> UIView {
		guard let superView = superview else {
			preconditionFailure("No superview for \(self)")
		}

		translatesAutoresizingMaskIntoConstraints = false
		centerXAnchor.constraint(equalTo: superView.centerXAnchor).isActive = true
		return self
	}

	/// Anchors `self` to the center of super view along the Y axis.
	///
	/// - Returns: `self`
	@discardableResult
	func anchorToMiddleY() -> UIView {
		guard let superView = superview else {
			preconditionFailure("No superview for \(self)")
		}

		translatesAutoresizingMaskIntoConstraints = false
		centerYAnchor.constraint(equalTo: superView.centerYAnchor).isActive = true
		return self
	}

	/// Anchors `self` to the center of super view along the X and Y axis.
	///
	/// - Returns: `self`
	@discardableResult
	func anchorToMiddle() -> UIView {
		guard let superView = superview else {
			preconditionFailure("No superview for \(self)")
		}

		translatesAutoresizingMaskIntoConstraints = false
		centerXAnchor.constraint(equalTo: superView.centerXAnchor).isActive = true
		centerYAnchor.constraint(equalTo: superView.centerYAnchor).isActive = true
		return self
	}

	/// Anchors `self` to the left side of super view.
	///
	/// - Parameter padding: The padding need to be applied. Default value is 0.
	/// - Returns: `self`
	@discardableResult
	func anchorToLeft(_ padding: CGFloat = 0.0) -> UIView {
		guard let superView = superview else {
			preconditionFailure("No superview for \(self)")
		}

		translatesAutoresizingMaskIntoConstraints = false
		leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: padding).isActive = true
		return self
	}

	/// Anchors `self` to the right side of super view.
	///
	/// - Parameter padding: The padding need to be applied. Default value is 0.
	/// - Returns: `self`
	@discardableResult
	func anchorToRight(_ padding: CGFloat = 0.0) -> UIView {
		guard let superView = superview else {
			preconditionFailure("No superview for \(self)")
		}

		translatesAutoresizingMaskIntoConstraints = false
		let trailing = trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: -padding)
		trailing.priority = .init(999)
		trailing.isActive = true
		return self
	}

	/// Anchors `self` to the top of super view.
	///
	/// - Parameters:
	///   - padding: The padding need to be applied. Default value is 0.
	///   - toSafeLayout: Tells whether anchoring to safe layout is needed. Default value is false.
	/// - Returns: `self`
	@discardableResult
	func anchorToTop(_ padding: CGFloat = 0.0, toSafeLayout: Bool = false) -> UIView {
		guard let superView = superview else {
			preconditionFailure("No superview for \(self)")
		}

		translatesAutoresizingMaskIntoConstraints = false
		if toSafeLayout {
			let top = topAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.topAnchor,
			                               constant: padding)
			top.isActive = true
		}
		else {
			let top = topAnchor.constraint(equalTo: superView.topAnchor, constant: padding)
			top.isActive = true
		}

		return self
	}

	/// Anchors `self` to the bottom of super view.
	///
	/// - Parameters:
	///   - padding: The padding need to be applied. Default value is 0.
	///   - toSafeLayout: Tells whether anchoring to safe layout is needed. Default value is false.
	/// - Returns: `self`
	@discardableResult
	func anchorToBottom(_ padding: CGFloat = 0.0, toSafeLayout: Bool = false) -> UIView {
		guard let superView = superview else {
			preconditionFailure("No superview for \(self)")
		}

		translatesAutoresizingMaskIntoConstraints = false
		if toSafeLayout {
			bottomAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.bottomAnchor,
			                        constant: -padding).isActive = true
		}
		else {
			bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: -padding).isActive = true
		}

		return self
	}

	/// Sets the width of `self` to the requested value.
	///
	/// - Parameter constant: The requested width.
	/// - Returns: `self`
	@discardableResult
	func setWidth(with constant: CGFloat) -> UIView {
		translatesAutoresizingMaskIntoConstraints = false
		widthAnchor.constraint(equalToConstant: constant).isActive = true
		return self
	}

	/// Sets the height of `self` to the requested value.
	///
	/// - Parameter constant: The requested height.
	/// - Returns: `self`
	@discardableResult
	func setHeight(with constant: CGFloat) -> UIView {
		translatesAutoresizingMaskIntoConstraints = false
		heightAnchor.constraint(equalToConstant: constant).isActive = true
		return self
	}
}
