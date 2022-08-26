import ExtensionKit
import Foundation
import os.log

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public struct ConnectingAppExtensionConfiguration: AppExtensionConfiguration {
	public typealias ConnectionHandler = (NSXPCConnection) throws -> Bool

	public let handler: ConnectionHandler
	private let logger = Logger(subsystem: "com.chimehq.Extendable", category: "ConnectionAppExtensionConfiguration")

	public init(_ handler: @escaping ConnectionHandler) {
		self.handler = handler
	}

	public func accept(connection: NSXPCConnection) -> Bool {
		logger.debug("accepting connection")

		do {
			let value = try handler(connection)

			logger.debug("accepted connection result: \(value)")

			return value
		} catch {
			logger.debug("accepting connection failed: \(String(describing: error), privacy: .public)")

			return false
		}
	}
}

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public final class ConnectingExtension<Extension: ConnectableExtension> {
	private var appEx: Extension? = nil
	public let activates: Bool

	public init(activates: Bool = true) {
		self.activates = activates
	}

	public var configuration: ConnectingAppExtensionConfiguration {
		// I wanted to make this self capture weak, but the object was then being deallocated, and
		// I don't understand why yet
		return ConnectingAppExtensionConfiguration { connection in
			self.appEx = try Extension(connection: connection)

			if self.activates {
				connection.activate()
			}

			return true
		}
	}
}
