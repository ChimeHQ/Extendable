#if canImport(ExtensionKit)
import ExtensionKit

@available(macOS 13.0, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension AppExtensionProcess {
	/// Async init that is compatible with an actor-isolated context.
	public init(appExtensionIdentity identity: AppExtensionIdentity, onInterruption handler: @escaping @Sendable () -> Void = {}) async throws {
		let config = AppExtensionProcess.Configuration(appExtensionIdentity: identity, onInterruption: handler)

		try await self.init(configuration: config)
	}
}
#endif
