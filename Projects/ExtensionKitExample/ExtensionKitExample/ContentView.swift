import ExtendableHost
import SwiftUI
import ExtensionFoundation

struct ContainerView<Content: View>: View {
	let content: Content

	init(@ViewBuilder content: () -> Content) {
		self.content = content()
	}

	var body: some View {
		#if os(macOS)
		HStack {
			content
		}
		#else
		VStack {
			content
		}
		#endif
	}
}

struct ContentView: View {
	@State private var monitor = try! AppExtensionMonitor(id: "com.chimehq.ExtensionKitExample.extension")

	private var identities: [AppExtensionIdentity] {
		monitor.identities
	}

    var body: some View {
        VStack {
            Text("ExtensionKit Host Application")
			ContainerView {
				AppExtensionBrowserView()
					.border(Color.blue, width: 2)
				List(monitor.identities, id: \.workaroundID) { identity in
					VStack {
						Text("host: \(identity.bundleIdentifier)")
						Text("point: \(identity.extensionPointIdentifier)")
						ExtensionHostingView(
							identity: identity,
							sceneID: "example-scene",
							connectionHandler: { connection in
								print("connection: ", connection)

								connection.activate()
							}
						)
						.border(Color.purple, width: 2)
					}
					.padding()
					.border(Color.red, width: 2)
				}
			}
        }
        .padding()
    }
}

//#Preview {
//    ContentView()
//}
