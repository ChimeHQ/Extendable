import Foundation
import os.log

public typealias ConnectionHandler = (NSXPCConnection) throws -> Void

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
struct ConnectionAccepter {
	private let logger = Logger(subsystem: "com.chimehq.Extendable", category: "ConnectionAccepter")

	let handler: ConnectionHandler

	init(_ handler: @escaping ConnectionHandler) {
		self.handler = handler
	}

	func accept(connection: NSXPCConnection) -> Bool {
		logger.debug("accepting connection")

		do {
			try handler(connection)

			logger.debug("accepted connection")

			connection.activate()

			return true
		} catch {
			logger.debug("accepting connection failed: \(String(describing: error), privacy: .public)")

			return false
		}
	}
}
