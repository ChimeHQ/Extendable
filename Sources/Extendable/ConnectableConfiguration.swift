import ExtensionFoundation
import Foundation

@MainActor @preconcurrency
public struct ConnectableConfiguration: AppExtensionConfiguration {

	private var handler: @MainActor (NSXPCConnection) -> Bool

	@available(macOS 15.0, iOS 26, *)
	@MainActor @preconcurrency
	public init(
		onSessionRequest requestHandler: @escaping @Sendable (XPCListener.IncomingSessionRequest) -> XPCListener.IncomingSessionRequest.Decision
	) {
		preconditionFailure()
	}

	@MainActor @preconcurrency
	public init(onConnection connectionHandler: @escaping @Sendable (NSXPCConnection) -> Bool) {
		self.handler = connectionHandler
	}

	nonisolated public func accept(connection: NSXPCConnection) -> Bool {
		MainActor.assumeIsolated {
			handler(connection)
		}
	}
}
