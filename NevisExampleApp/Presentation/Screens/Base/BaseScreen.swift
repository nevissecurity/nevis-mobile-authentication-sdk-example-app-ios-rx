//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import FittedSheets
import KRProgressHUD
import RxSwift
import Then
import UIKit

/// View that acts as a base for any other concrete view.
/// Creates the basic UI structure and declares binders to make loading and error handling related task easier.
class BaseScreen: UIViewController {

	// MARK: - Constants

	/// Enumeration for the constants.
	private enum Constants {
		/// Initial height of the logging component.
		static let loggingInitialHeight: CGFloat = 80.0
		/// Padding of the logging component.
		static let loggingPadding: CGFloat = 50.0
	}

	// MARK: - UI

	/// The main scroll view.
	var scrollView = UIScrollView()

	/// The content view of the scroll view.
	var scrollableContentView = UIView()

	/// Stack view for content that need to be presented at the top of the screen.
	var topStackView = UIStackView()

	/// Stack view for content that need to be presented in the middle of the screen.
	var contentStackView = UIStackView()

	/// Stack view for content that need to be presented at the bottom of the screen.
	var bottomStackView = UIStackView()

	/// The sheet component of the view.
	private var sheet: SheetViewController?

	/// The bottom constraint.
	private var bottomConstraint: NSLayoutConstraint?

	// MARK: - Initialization

	/// Creates a new instance.
	init() {
		super.init(nibName: nil, bundle: nil)
	}

	@available(*, unavailable)
	required init?(coder _: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: - Lifecycle

extension BaseScreen {

	/// Override of the `viewDidLoad()` lifecycle method. Sets up the user interface.
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		setupScrollView()
		setupTopStackView()
		setupContentStackView()
		setupBottomStackView()
	}

	/// Override of the `viewWillAppear(_:)` lifecycle method.
	///
	/// - parameter animated: If *true*, the view is being added to the window using an animation.
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setupBottomSheet()
	}

	/// Override of the `viewDidLayoutSubviews()` lifecycle method.
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		bottomConstraint?.constant = -view.safeAreaInsets.bottom - Constants.loggingPadding
	}
}

// MARK: - Setups

extension BaseScreen {

	/// Sets up the main scroll view and its content view.
	func setupScrollView() {
		scrollView.do {
			view.addSubview($0)
			$0.anchorToTop(toSafeLayout: true)
			$0.anchorToRight()
			$0.anchorToLeft()
			$0.anchorToBottom()
			$0.contentInsetAdjustmentBehavior = .never
			$0.delaysContentTouches = true
			$0.canCancelContentTouches = true
		}

		scrollView.addSubview(scrollableContentView)
		scrollableContentView.do {
			$0.anchorToSuperView()
			NSLayoutConstraint.activate([
				$0.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
				$0.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor),
			])
		}
	}

	/// Sets up the top stack view.
	func setupTopStackView() {
		topStackView.do {
			scrollableContentView.addSubview($0)
			$0.axis = .vertical
			$0.anchorToTop()
			$0.anchorToLeft()
			$0.anchorToRight()
		}
	}

	/// Sets up the middle stack view.
	func setupContentStackView() {
		contentStackView.do {
			scrollableContentView.addSubview($0)
			$0.axis = .vertical
			$0.topAnchor.constraint(equalTo: topStackView.bottomAnchor).isActive = true
			$0.anchorToLeft()
			$0.anchorToRight()
		}
	}

	/// Sets up the bottom stack view.
	func setupBottomStackView() {
		bottomStackView.do {
			scrollableContentView.addSubview($0)
			$0.axis = .vertical
			$0.topAnchor.constraint(greaterThanOrEqualTo: contentStackView.bottomAnchor).isActive = true
			$0.anchorToLeft()
			$0.anchorToRight()
			bottomConstraint = $0.bottomAnchor.constraint(equalTo: scrollableContentView.bottomAnchor)
			bottomConstraint?.isActive = true
		}
	}

	/// Sets up the bottom sheet.
	func setupBottomSheet() {
		guard let loggingScreen = DependencyProvider.shared.container.resolve(LoggingScreen.self) else {
			return
		}

		var options = SheetOptions()
		options.useInlineMode = true
		options.useFullScreenMode = false
		options.shouldExtendBackground = false
		options.pullBarHeight = 0

		sheet = SheetViewController(
			controller: loggingScreen,
			sizes: [.fixed(Constants.loggingInitialHeight), .percent(0.5), .fullscreen],
			options: options
		)

		sheet?.cornerRadius = 0
		sheet?.allowPullingPastMaxHeight = false
		sheet?.allowPullingPastMinHeight = false
		sheet?.allowGestureThroughOverlay = true
		sheet?.treatPullBarAsClear = true
		sheet?.dismissOnPull = false
		sheet?.dismissOnOverlayTap = false
		sheet?.overlayColor = .clear
		sheet?.animateIn(to: view, in: self)
	}
}

// MARK: - Actions

extension BaseScreen {

	/// Adds an item to the top.
	///
	/// - parameter item: The item that need to be added.
	/// - parameter spacing: The bottom spacing. Default value is 0.
	/// - parameter leftSpacing: The left spacing. Default value is 16.0.
	/// - parameter rightSpacing: The right spacing. Default value is 16.0.
	/// - parameter topSpacing: The top spacing. Default value is 0.
	func addItemToTop(_ item: UIView,
	                  spacing: CGFloat = 0.0,
	                  leftSpacing: CGFloat = 16.0,
	                  rightSpacing: CGFloat = 16.0,
	                  topSpacing: CGFloat = 0.0) {
		topStackView.addItem(item,
		                     spacing: spacing,
		                     leftSpacing: leftSpacing,
		                     rightSpacing: rightSpacing,
		                     topSpacing: topSpacing)
	}

	/// Adds an item to the middle of the screen.
	///
	/// - parameter item: The item that need to be added.
	/// - parameter spacing: The bottom spacing. Default value is 0.
	/// - parameter leftSpacing: The left spacing. Default value is 16.0.
	/// - parameter rightSpacing: The right spacing. Default value is 16.0.
	/// - parameter topSpacing: The top spacing. Default value is 0.
	func addItem(_ item: UIView,
	             spacing: CGFloat = 0.0,
	             leftSpacing: CGFloat = 16.0,
	             rightSpacing: CGFloat = 16.0,
	             topSpacing: CGFloat = 0.0) {
		contentStackView.addItem(item,
		                         spacing: spacing,
		                         leftSpacing: leftSpacing,
		                         rightSpacing: rightSpacing,
		                         topSpacing: topSpacing)
	}

	/// Adds an item to the center of the screen.
	///
	/// - parameter item: The item that need to be added.
	/// - parameter spacing: The top and bottom spacing. Default value is 0.
	func addItemCentered(_ item: UIView, spacing: CGFloat = 0) {
		contentStackView.addItemCentered(item, spacing: spacing)
	}

	/// Adds an item to the bottom of the screen.
	///
	/// - parameter item: The item that need to be added.
	/// - parameter spacing: The bottom spacing. Default value is 0.
	/// - parameter leftSpacing: The left spacing. Default value is 16.0.
	/// - parameter rightSpacing: The right spacing. Default value is 16.0.
	/// - parameter topSpacing: The top spacing. Default value is 0.
	func addItemToBottom(_ item: UIView,
	                     spacing: CGFloat = 0.0,
	                     leftSpacing: CGFloat = 16.0,
	                     rightSpacing: CGFloat = 16.0,
	                     topSpacing: CGFloat = 0.0) {
		bottomStackView.addItem(item,
		                        spacing: spacing,
		                        leftSpacing: leftSpacing,
		                        rightSpacing: rightSpacing,
		                        topSpacing: topSpacing)
	}
}

// MARK: - Private Interface

private extension BaseScreen {

	/// Shows the loading popup.
	func showLoading() {
		KRProgressHUD.show(withMessage: L10n.Screen.loading)
	}

	/// Hides the loading popup.
	func dismissLoading() {
		KRProgressHUD.dismiss()
	}
}

// MARK: - Reactive

extension Reactive where Base: BaseScreen {

	/// Bindable sink for `isLoading` property.
	var isLoading: Binder<Bool> {
		Binder(base) { vc, isLoading in
			isLoading ? vc.showLoading() : vc.dismissLoading()
		}
	}

	/// Bindable sink for `error` property.
	var error: Binder<Error> {
		Binder(base) { _, error in
			let errorHandlerChain = DependencyProvider.shared.container.resolve(ErrorHandlerChain.self)
			errorHandlerChain?.handle(error: error)
		}
	}
}
