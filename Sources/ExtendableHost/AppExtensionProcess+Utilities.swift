import ExtensionKit

@available(macOS 13.0, *)
extension AppExtensionProcess {
	/// Async init that is compatible with an actor-isolated context.
	public init(appExtensionIdentity identity: AppExtensionIdentity, onInterruption handler: @escaping @Sendable () -> Void = {}) async throws {
		let config = AppExtensionProcess.Configuration(appExtensionIdentity: identity, onInterruption: handler)

		try await self.init(configuration: config)
	}
}
