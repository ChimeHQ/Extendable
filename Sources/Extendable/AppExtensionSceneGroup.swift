import ExtensionKit

/// Can be used to group multiple `AppExtensionScene` views.
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public struct AppExtensionSceneGroup<Content: AppExtensionScene>: AppExtensionScene {
	private let content: Content

	public init(@AppExtensionSceneBuilder content: () throws -> Content) rethrows {
		self.content = try content()
	}

	public var body: some AppExtensionScene {
		return content
	}
}
