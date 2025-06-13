import ExtensionKit
import SwiftUI

@available(macOS 13, iOS 26, *)
extension AppExtensionIdentity {
	/// exists because something is wrong with the Identifiable conformance with 26 beta 1
	public var workaroundID: ID {
		"\(bundleIdentifier)-\(extensionPointIdentifier)"
	}
}

extension StaticString {
	/// Convert to a `String`.
	///
	/// Why on Earth isn't this this in the standard library?
	var string: String {
		withUTF8Buffer { utf8Buffer in
			String(decoding: utf8Buffer, as: UTF8.self)
		}
	}
}

/// A cross-platform and backwards-compatible version of `AppExtensionPoint.Monitor`.
@available(macOS 14, iOS 26, *)
@Observable
public final class AppExtensionMonitor {
#if os(macOS)
	public private(set) var identities: [AppExtensionIdentity] = []

	@ObservationIgnored
	private var task: Task<Void, Never>?

	public init(id: StaticString) throws {
		let identitiesSequence = try AppExtensionIdentity.matching(appExtensionPointIDs: id.string)

		self.task = Task { [weak self] in
			for await value in identitiesSequence {
				self?.identities = value
			}
		}
	}

	deinit {
		task?.cancel()
	}
	#else
	@ObservationIgnored
	private var task: Task<Void, Never>?

	@ObservationIgnored
	private var monitor: AppExtensionPoint.Monitor?

	public init(id: StaticString) throws {
		let point = try AppExtensionPoint(identifier: id)

		self.task = Task { [weak self] in
			self?.monitor = try! await AppExtensionPoint.Monitor(appExtensionPoint: point)
		}
	}

	public var identities: [AppExtensionIdentity] {
		monitor?.identities ?? []
	}

	#endif
}
