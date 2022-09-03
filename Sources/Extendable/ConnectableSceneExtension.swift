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
public protocol ConnectableSceneExtension: ConnectableExtension {
	associatedtype Content : AppExtensionScene

	var scene: Content { get }
}
#else
/// Defines an interface between a host and view-based extension.
///
/// This type provides more structure to a view-based extension. You can also
/// optionally use the `acceptConnection(_:, for:)` method to return a new `Body`
/// that uses the connection as input. Handy for putting interface-related objects
/// in the enviroment.
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public protocol ConnectableSceneExtension<Content>: ConnectableExtension {
	associatedtype Content : AppExtensionScene

	var scene: Content { get }
}
#endif

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public extension ConnectableSceneExtension {
	var configuration: AppExtensionSceneConfiguration {
		return AppExtensionSceneConfiguration(scene, configuration: globalConfiguration)
	}
}
