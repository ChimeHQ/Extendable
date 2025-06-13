import ExtensionKit
import SwiftUI

#if os(macOS)
@available(macOS 13, *)
public struct ExtensionHostingView: NSViewControllerRepresentable {
	public typealias ConnectionHandler = (NSXPCConnection) throws -> Void

	public var connectionHandler: ConnectionHandler?

	public let configuration: EXHostViewController.Configuration?

	public init(configuration: EXHostViewController.Configuration?, connectionHandler: ConnectionHandler? = nil) {
		self.configuration = configuration
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
}
#else
@available(iOS 26, *)
public struct ExtensionHostingView: UIViewControllerRepresentable {
	public typealias ConnectionHandler = (NSXPCConnection) throws -> Void

	public var connectionHandler: ConnectionHandler?

	public let configuration: EXHostViewController.Configuration?

	public init(configuration: EXHostViewController.Configuration?, connectionHandler: ConnectionHandler? = nil) {
		self.configuration = configuration
		self.connectionHandler = connectionHandler
	}

	public func makeUIViewController(context: Context) -> EXHostViewController {
		let controller = EXHostViewController()

		controller.delegate = context.coordinator

		return controller
	}

	public func updateUIViewController(_ viewController: EXHostViewController, context: Context) {
		viewController.configuration = configuration
		context.coordinator.connectionHandler = connectionHandler
	}
}
#endif

@available(macOS 13.0, iOS 26, *)
extension ExtensionHostingView {
	public init(identity: AppExtensionIdentity?, sceneID: String = "default", connectionHandler: ConnectionHandler? = nil) {
		self.configuration = identity.map { .init(appExtension: $0, sceneID: sceneID) }
		self.connectionHandler = connectionHandler
	}

	public func makeCoordinator() -> Coordinator {
		return ExtensionHostingView.Coordinator()
	}

	public class Coordinator: NSObject, EXHostViewControllerDelegate {
		public var connectionHandler: ConnectionHandler?

		public func hostViewControllerDidActivate(_ viewController: EXHostViewController) {
			guard let handler = connectionHandler else { return }

			do {
				let connection = try viewController.makeXPCConnection()
				
				try handler(connection)

				connection.activate()
			} catch {
				print("Unable to create connection: \(String(describing: error))")
			}
		}
	}
}
