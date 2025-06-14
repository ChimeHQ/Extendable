import Foundation
import ExtensionKit
import SwiftUI

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public struct ConnectingAppExtensionConfiguration: AppExtensionConfiguration {
	let accepter: ConnectionAccepter

	public init(_ handler: @escaping ConnectionHandler) {
		self.accepter = ConnectionAccepter(handler)
	}

	public func accept(connection: NSXPCConnection) -> Bool {
		return accepter.accept(connection: connection)
	}
}

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public protocol ConnectableExtension: AppExtension {
	func acceptConnection(_ connection: NSXPCConnection) throws
}

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public extension ConnectableExtension {
	/// The global, per-exension configuration
	///
	/// This configuration applies to the extension process, and
	/// its connection corresponds to `AppExtensionProcess`. This
	/// will be used for the `configuration` property by default.
	var globalConfiguration: ConnectingAppExtensionConfiguration {
		return ConnectingAppExtensionConfiguration { connection in
			try self.acceptConnection(connection)
		}
	}

	var configuration: ConnectingAppExtensionConfiguration {
		return globalConfiguration
	}
}


@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public protocol NewConnectableExtension: AppExtension {
	func acceptConnection(_ connection: NSXPCConnection) throws
}
