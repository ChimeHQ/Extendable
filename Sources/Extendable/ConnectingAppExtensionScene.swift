import ExtensionKit
import SwiftUI

@MainActor
private final class ConnectingSceneModel<Content: View>: ObservableObject {
	@Published var view: Content

	init(initial: Content) {
		self.view = initial
	}
}

@MainActor
private struct ConnectingView<Content: View>: View {
	@ObservedObject var model: ConnectingSceneModel<Content>

	init(model: ConnectingSceneModel<Content>) {
		self.model = model
	}

	var body: some View {
		model.view
	}
}

/// An `AppExtensionScene` that generates content as function of the host connection.
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
@MainActor
public struct ConnectingAppExtensionScene<Content: View>: AppExtensionScene {
	public let sceneID: String
	let accepter: ConnectionAccepter
	private let model: ConnectingSceneModel<Content>
	private let connectingView: ConnectingView<Content>

	public init(sceneID: String, @ViewBuilder content: @escaping (String, NSXPCConnection?) throws -> Content) {
		self.sceneID = sceneID

		// This is lame, but it is a programming error to throw when the connection
		// is nil. That must be supported.
		let sceneModel = ConnectingSceneModel(initial: try! content(sceneID, nil))

		self.model = sceneModel
		self.connectingView = ConnectingView(model: sceneModel)

		self.accepter = ConnectionAccepter({ conn in
			sceneModel.view = try content(sceneID, conn)
		})
	}


	public nonisolated var body: some AppExtensionScene {
		MainActor.assumeIsolated {
			PrimitiveAppExtensionScene(id: sceneID) {
				connectingView
			} onConnection: { connection in
				return accepter.accept(connection: connection)
			}
		}
	}
}
