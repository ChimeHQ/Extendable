import ExtensionKit
import SwiftUI

#if swift(>=5.7)
/// Defines an interface between a host and view-based extension.
///
/// This type provides more structure to a view-based extension. You can also
/// optionally use the `acceptConnection(_:, for:)` method to return a new `Body`
/// that uses the connection as input. Handy for putting interface-related objects
/// in the enviroment.
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public protocol ConnectableSceneExtension<Body>: ConnectableExtension {
	associatedtype Body : View

	func scene(for id: String, connection: NSXPCConnection?) throws -> Body
}
#else
/// Defines an interface between a host and view-based extension.
///
/// This type provides more structure to a view-based extension. You can also
/// optionally use the `acceptConnection(_:, for:)` method to return a new `Body`
/// that uses the connection as input. Handy for putting interface-related objects
/// in the enviroment.
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public protocol ConnectableSceneExtension: ConnectableExtension {
	associatedtype Body : View

	func scene(for id: String, connection: NSXPCConnection?) throws -> Body
}
#endif

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public extension ConnectableSceneExtension {
	func scene(for id: String) throws -> Body {
		try scene(for: id, connection: nil)
	}

	/// The extension scene configuration
	///
	/// This configuration applies to both the extension process, and
	/// its per-view scene. This will be used for the `configuration` property by default.
	var configuration: AppExtensionSceneConfiguration {
		do {
			let scene = try ConnectingAppExtensionScene(sceneID: "default", appex: self)

			return AppExtensionSceneConfiguration(scene, configuration: globalConfiguration)
		} catch {
			let scene = PrimitiveAppExtensionScene(id: "default") {
				Text("failed to construct initial scene: \(String(describing: error))")
			} onConnection: { connection in
				return false
			}

			return AppExtensionSceneConfiguration(scene, configuration: globalConfiguration)
		}
	}
}
