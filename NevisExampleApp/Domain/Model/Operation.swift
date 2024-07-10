//
// Nevis Mobile Authentication SDK Example App
//
// Copyright © 2022. Nevis Security AG. All rights reserved.
//

import Foundation

/// Domain model of a FIDO UAF operation.
public enum Operation {
	/// Client initialization operation.
	case initClient

	/// Out-of-Band payload decode operation.
	case payloadDecode

	/// Out-of-Band operation.
	case outOfBand

	/// FIDO registration operation.
	case registration

	/// FIDO authentication operation.
	case authentication

	/// FIDO deregistration operation.
	case deregistration

	/// PIN change operation.
	case pinChange

	/// Password change operation.
	case passwordChange

	/// Device information change operation.
	case deviceInformationChange

	/// Local data operation.
	case localData

	/// Unknown operation.
	case unknown
}
