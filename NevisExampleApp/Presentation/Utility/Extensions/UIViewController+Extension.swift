//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

extension Reactive where Base: UIViewController {

	/// Bindable sink for `viewDidLoad` event.
	var viewDidLoad: ControlEvent<()> {
		let source = methodInvoked(#selector(Base.viewDidLoad)).map { _ in }
		return ControlEvent(events: source)
	}

	/// Bindable sink for `viewWillAppear` event.
	var viewWillAppear: ControlEvent<Bool> {
		let source = methodInvoked(#selector(Base.viewWillAppear)).map { $0.first as? Bool ?? false }
		return ControlEvent(events: source)
	}

	/// Bindable sink for `viewDidAppear` event.
	var viewDidAppear: ControlEvent<Bool> {
		let source = methodInvoked(#selector(Base.viewDidAppear)).map { $0.first as? Bool ?? false }
		return ControlEvent(events: source)
	}

	/// Bindable sink for `viewWillDisappear` event.
	var viewWillDisappear: ControlEvent<Bool> {
		let source = methodInvoked(#selector(Base.viewWillDisappear)).map { $0.first as? Bool ?? false }
		return ControlEvent(events: source)
	}

	/// Bindable sink for `viewDidDisappear` event.
	var viewDidDisappear: ControlEvent<Bool> {
		let source = methodInvoked(#selector(Base.viewDidDisappear)).map { $0.first as? Bool ?? false }
		return ControlEvent(events: source)
	}
}
