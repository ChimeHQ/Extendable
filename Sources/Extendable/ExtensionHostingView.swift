import ExtensionKit
import SwiftUI

@available(macOS 13.0, *)
public struct ExtensionHostingView: NSViewControllerRepresentable {
	public typealias NSViewControllerType = EXHostViewController

	let configuration: EXHostViewController.Configuration

	init(configuration: EXHostViewController.Configuration) {
		self.configuration = configuration
	}

	init(identity: AppExtensionIdentity, sceneID: String) {
		self.init(configuration: .init(appExtension: identity, sceneID: sceneID))
	}

	public func makeNSViewController(context: Context) -> EXHostViewController {
		return EXHostViewController()
	}

	public func updateNSViewController(_ viewController: EXHostViewController, context: Context) {
		viewController.configuration = configuration
	}
}
