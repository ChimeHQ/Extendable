import Foundation
import os.log

public typealias ConnectionHandler = (NSXPCConnection) throws -> Void

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

			#if compiler(>=5.7)
			// this API is available in 11.0, but only exposed in the headers for 13.0
			connection.activate()
			#else
			connection.resume()
			#endif

			return true
		} catch {
			logger.debug("accepting connection failed: \(String(describing: error), privacy: .public)")

			return false
		}
	}
}
