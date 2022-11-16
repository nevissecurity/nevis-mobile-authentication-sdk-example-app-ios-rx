//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import AVFoundation
import MercariQRScanner
import RxSwift
import UIKit

/// The Qr Scanner view.
final class QrScannerScreen: BaseScreen, Screen {

	// MARK: - UI

	/// The Qr Scanner view.
	private var qrScannerView: QRScannerView?

	// MARK: - Properties

	/// The view model.
	var viewModel: QrScannerViewModel!

	/// Thread safe bag that disposes added disposables.
	private let disposeBag = DisposeBag()

	/// Observable sequence used to emit the scanned string.
	private let tokenSubject = PublishSubject<String>()

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameter viewModel: The view model.
	init(viewModel: QrScannerViewModel) {
		self.viewModel = viewModel
		super.init()
	}

	/// :nodoc:
	deinit {
		os_log("QrScannerScreen", log: OSLog.deinit, type: .debug)
	}
}

// MARK: - Lifecycle

extension QrScannerScreen {

	/// Override of the `viewDidLoad()` lifecycle method. Sets up the user interface and binds the view model.
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
	}

	/// Override of the `viewWillAppear(_:)` lifecycle method. Binds the view model.
	///
	/// - parameter animated: If *true*, the view is being added to the window using an animation.
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		bindViewModel()
	}

	/// Override of the `viewDidDisappear(_:)` lifecycle method.
	///
	/// - parameter animated: If *true*, the view is being removed from the window using an animation.
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		qrScannerView?.stopRunning()
	}

	func refresh() {
		// do nothing
	}
}

// MARK: - Setups

/// :nodoc:
private extension QrScannerScreen {

	func setupUI() {
		setupQRScanner()
	}

	func setupQRScanner() {
		switch AVCaptureDevice.authorizationStatus(for: .video) {
		case .authorized:
			setupQRScannerView()
		case .notDetermined:
			AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
				if granted {
					DispatchQueue.main.async { [weak self] in
						self?.setupQRScannerView()
					}
				}
			}
		default:
			showAlert()
		}
	}

	func setupQRScannerView() {
		qrScannerView = QRScannerView(frame: view.bounds)
		view.addSubview(qrScannerView!)
		qrScannerView?.configure(delegate: self, input: .init(isBlurEffectEnabled: true))
		qrScannerView?.startRunning()
	}

	func showAlert() {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
			let alert = UIAlertController(title: "Error",
			                              message: "Camera is required to use in this application",
			                              preferredStyle: .alert)
			alert.addAction(.init(title: "OK", style: .default))
			self?.present(alert, animated: true)
		}
	}
}

// MARK: - Binding

/// :nodoc:
private extension QrScannerScreen {

	func bindViewModel() {
		assert(viewModel != nil)
		let input = QrScannerViewModel.Input(qrContent: tokenSubject.asDriverOnErrorJustComplete())
		let output = viewModel.transform(input: input)
		[output.qrCodeRead.drive(),
		 output.error.drive(rx.error)]
			.forEach { $0.disposed(by: disposeBag) }
	}
}

// MARK: - QRScannerViewDelegate

/// :nodoc:
extension QrScannerScreen: QRScannerViewDelegate {
	func qrScannerView(_: QRScannerView, didFailure error: QRScannerError) {
		print(error.localizedDescription)
	}

	func qrScannerView(_: QRScannerView, didSuccess code: String) {
		tokenSubject.on(.next(code))
	}

	func qrScannerView(_: QRScannerView, didChangeTorchActive _: Bool) {}
}
