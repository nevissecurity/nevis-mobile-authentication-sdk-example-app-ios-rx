//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import Foundation

/// A convenient timer that is run until the defined `TimeInterval`, then invalidated.
/// Calls the given `intervalCallback` periodically in each `refreshInveral`, until the timer is invalidated.
final class InteractionCountDownTimer {

	// MARK: - Properties

	/// The interval for how long the timer should run.
	let timerLifeTime: TimeInterval

	/// The interval when to call the `intervalCallback`.
	let refreshInterval: TimeInterval

	/// The callback that is called providing the remaining time in the timer.
	let intervalCallback: ((Int) -> ())?

	/// Tells whether the timer is valid and running.
	var isValid: Bool {
		timer?.isValid ?? false
	}

	/// The internal timer instance.
	private var timer: Timer?

	/// The timer time interval.
	private var endOfTimer: TimeInterval = 0.0

	// MARK: - Initialization

	/// Creates a new instance.
	///
	/// - Parameters:
	///   - timerLifeTime: The interval for how long the timer should run.
	///   - refreshInterval: The interval when to call the `intervalCallback`. Default value is 1.0.
	///   - intervalCallback: The callback that is called providing the remaining time in the timer. Default value is *nil*.
	public init(timerLifeTime: TimeInterval,
	            refreshInterval: TimeInterval = 1.0,
	            intervalCallback: ((Int) -> ())? = nil) {
		self.timerLifeTime = timerLifeTime
		self.refreshInterval = refreshInterval
		self.intervalCallback = intervalCallback
	}
}

// MARK: - Actions

extension InteractionCountDownTimer {

	/// Starts the timer.
	func start() {
		endOfTimer = Date(timeIntervalSinceNow: timerLifeTime).timeIntervalSinceReferenceDate
		timer = Timer.scheduledTimer(withTimeInterval: refreshInterval, repeats: true) { timer in
			var remainingTime = round(self.endOfTimer - Date().timeIntervalSinceReferenceDate)
			if remainingTime < 1 {
				remainingTime = 0
				timer.invalidate()
			}
			self.intervalCallback?(Int(remainingTime))
		}
	}

	/// Cancels the timer.
	func cancel() {
		timer?.invalidate()
	}
}
