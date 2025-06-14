import Foundation
import ExtensionFoundation
import ExtensionKit
import SwiftUI

import Extendable

/// The AppExtensionConfiguration that will be provided by this extension.
/// This is typically defined by the extension host in a framework.
struct ExampleConfiguration<E:ExampleExtension>: AppExtensionConfiguration {
    let appExtension: E
    
    init(_ appExtension: E) {
        self.appExtension = appExtension
    }
    
    /// Determine whether to accept the XPC connection from the host.
    func accept(connection: NSXPCConnection) -> Bool {
        // TODO: Configure the XPC connection and return true
        return true
    }
}

/// The AppExtension protocol to which this extension will conform.
/// This is typically defined by the extension host in a framework.
protocol ExampleExtension : AppExtension {
    associatedtype Body: ExampleAppExtensionScene
    var body: Body { get }
}

/// The AppExtensionScene protocol to which this extension's scenes will conform.
/// This is typically defined by the extension host in a framework.
protocol ExampleAppExtensionScene: AppExtensionScene {}

/// An AppExtensionScene that this extension can provide.
/// This is typically defined by the extension host in a framework.
struct ExampleScene<Content: View>: ExampleAppExtensionScene {
    let sceneID = "example-scene"
    
    public init(content: @escaping () ->  Content) {
        self.content = content
    }
    
    private let content: () -> Content
    
    public var body: some AppExtensionScene {
        PrimitiveAppExtensionScene(id: sceneID) {
            content()
        } onConnection: { connection in
            // TODO: Configure the XPC connection and return true
            return true
        }
    }
}

extension ExampleExtension {
    var configuration: AppExtensionSceneConfiguration {
//		if #available(macOS 26, iOS 26, *) {
//			return AppExtensionSceneConfiguration(
//				self.body,
//				configuration: ConnectionHandler(onSessionRequest: { request in
//					let decision: XPCListener.IncomingSessionRequest.Decision = request.accept { (decodable: String) -> String? in
//						"hello: \(decodable)"
//					} cancellationHandler: { error in
//						print("cancellation: \(error)")
//					}
//
//					return decision
//				})
//			)
//		} else {
			return AppExtensionSceneConfiguration(
				self.body,
				configuration: ConnectableConfiguration(onConnection: { connection in
					print("incoming connection")

					return true
				})
			)
//		}
    }
}

@main
class HostExtension: ExampleExtension {
    required init() {
        // Initialize your extension here.
    }
    
    var body: some ExampleAppExtensionScene {
        ExampleScene {
            Text("Hello, app extension!")
        }
    }
}
