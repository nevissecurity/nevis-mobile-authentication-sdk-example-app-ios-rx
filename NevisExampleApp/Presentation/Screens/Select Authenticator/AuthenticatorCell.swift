//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import Reusable
import UIKit

/// Cell for displaying information about an authenticator.
class AuthenticatorCell: UITableViewCell, Reusable {

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameters:
	///  - style: A constant indicating a cell style.
	///  - reuseIdentifier: A string used to identify the cell object if it is to be reused for drawing multiple rows of a table view.
	override init(style _: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
		setupUI()
	}

	@available(*, unavailable)
	required init?(coder _: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Reuse

	/// Prepares a reusable cell for reuse by the table view's delegate.
	override func prepareForReuse() {
		super.prepareForReuse()
		textLabel?.text = ""
		detailTextLabel?.text = ""
		selectionStyle = .default
	}
}

// MARK: - Private setups

/// :nodoc:
private extension AuthenticatorCell {

	func setupUI() {
		textLabel?.do {
			$0.font = Style.normal.font
		}

		detailTextLabel?.do {
			$0.numberOfLines = 0
			$0.font = Style.detail.font
			$0.textColor = Style.detail.textColor
		}
	}
}

// MARK: - Binding

extension AuthenticatorCell {

	/// Binds the view model.
	///
	/// - Parameter viewModel: The model that need to be binded.
	func bind(viewModel: SelectAuthenticatorItemViewModel) {
		textLabel?.text = viewModel.title
		detailTextLabel?.text = viewModel.details
		selectionStyle = viewModel.isEnabled ? .default : .none
	}
}
