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
	public private(set) var identities: [AppExtensionIdentity] = []

	@ObservationIgnored
	private var task: Task<Void, Never>?

	@ObservationIgnored
	private var monitor: Any?

	public init(id: StaticString) throws {
		if #available(macOS 26, *) {
			let point = try AppExtensionPoint(identifier: id)

			self.task = Task { [weak self] in
				self?.monitor = try! await AppExtensionPoint.Monitor(appExtensionPoint: point)

				self?.publish()
			}

			return
		}

		#if os(macOS)
		let identitiesSequence = try AppExtensionIdentity.matching(appExtensionPointIDs: id.string)

			self.task = Task { [weak self] in
				for await value in identitiesSequence {
					self?.identities = value
				}
			}
		#endif

	}

	deinit {
		task?.cancel()
	}

	private var monitorIdentities: [AppExtensionIdentity] {
		guard
			#available(macOS 26.0, *),
			let monitor = monitor as? AppExtensionPoint.Monitor
		else {
			return []
		}

		return monitor.identities
	}

	private func subscribe() {
		withObservationTracking {
			monitorIdentities
		} onChange: { [weak self] in
			guard let self else { return }

			publish()
		}
	}

	private func publish() {
		self.identities = monitorIdentities

		Task {
			self.subscribe()
		}
	}
}
