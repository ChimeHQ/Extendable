#if os(macOS)
import ExtensionKit
import SwiftUI

@available(macOS 13.0, *)
public struct ExtensionHostingView: NSViewControllerRepresentable {
	public typealias ConnectionHandler = (NSXPCConnection) -> Void

	public var connectionHandler: ConnectionHandler?

	public let configuration: EXHostViewController.Configuration?

	public init(configuration: EXHostViewController.Configuration?, connectionHandler: ConnectionHandler? = nil) {
		self.configuration = configuration
		self.connectionHandler = connectionHandler
	}

	public init(identity: AppExtensionIdentity?, sceneID: String = "default", connectionHandler: ConnectionHandler? = nil) {
		self.configuration = identity.map { .init(appExtension: $0, sceneID: sceneID) }
		self.connectionHandler = connectionHandler
	}

	public func makeNSViewController(context: Context) -> EXHostViewController {
		let controller = EXHostViewController()

		controller.delegate = context.coordinator

		return controller
	}

	public func updateNSViewController(_ viewController: EXHostViewController, context: Context) {
		viewController.configuration = configuration
		context.coordinator.connectionHandler = connectionHandler
	}

	public func makeCoordinator() -> Coordinator {
		return ExtensionHostingView.Coordinator()
	}
}

@available(macOS 13.0, *)
extension ExtensionHostingView {
	@MainActor
	public class Coordinator: NSObject, EXHostViewControllerDelegate {
		public var connectionHandler: ConnectionHandler?

		public func shouldAccept(_ connection: NSXPCConnection) -> Bool {
			return true
		}

		public nonisolated func hostViewControllerDidActivate(_ viewController: EXHostViewController) {
			MainActor.assumeIsolated {
				guard let handler = connectionHandler else { return }

				do {
					let connection = try viewController.makeXPCConnection()

					handler(connection)

					connection.activate()
				} catch {
					print("Unable to create connection: \(String(describing: error))")
				}
			}
		}
	}
}
#endif
