import Foundation

public enum ConnectableExtensionError: Error {
	case connectionUnsupported
}

public protocol ConnectableExtension {
	init(connection: NSXPCConnection) throws
}
