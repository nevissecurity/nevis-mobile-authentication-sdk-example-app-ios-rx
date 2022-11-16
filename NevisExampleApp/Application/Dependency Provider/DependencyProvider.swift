//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import Swinject

/// The DI provider containing the assemblies and persisting the container.
final class DependencyProvider {

	// MARK: - Properties

	/// The shared ``DependencyProvider`` instance.
	static let shared = DependencyProvider()

	/// The DI container.
	let container = Container()

	/// The assembler.
	private let assembler: Assembler

	// MARK: - Initialization

	/// Creates a new instance.
	private init() {
		self.assembler = Assembler([AppAssembly()], container: container)
	}
}
