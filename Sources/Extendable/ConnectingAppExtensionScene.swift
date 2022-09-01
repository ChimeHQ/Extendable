import ExtensionKit
import SwiftUI

private struct ConnectingView<Content: View>: View {
	@ObservedObject var model: ConnectingSceneModel<Content>

	init(model: ConnectingSceneModel<Content>) {
		self.model = model
	}

	var body: some View {
		model.view
	}
}

private final class ConnectingSceneModel<Content: View>: ObservableObject {
	@Published var view: Content

	init(initial: Content) {
		self.view = initial
	}
}

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
struct ConnectingAppExtensionScene<Extension: ConnectableSceneExtension>: AppExtensionScene {
	typealias Content = Extension.Body

	let sceneID: String
	let accepter: ConnectionAccepter
	private let model: ConnectingSceneModel<Content>
	private let connectingView: ConnectingView<Content>

	init(sceneID: String, appex: Extension) throws {
		self.sceneID = sceneID

		let sceneModel = ConnectingSceneModel(initial: try appex.scene(for: sceneID))

		self.model = sceneModel
		self.connectingView = ConnectingView(model: sceneModel)

		self.accepter = ConnectionAccepter({ conn in
//			sceneModel.view = try appex.acceptConnection(conn, for: sceneID)
			sceneModel.view = try appex.scene(for: sceneID, connection: conn)
		})
	}

	var body: some AppExtensionScene {
		PrimitiveAppExtensionScene(id: sceneID) {
			connectingView
		} onConnection: { connection in
			return accepter.accept(connection: connection)
		}
	}
}
