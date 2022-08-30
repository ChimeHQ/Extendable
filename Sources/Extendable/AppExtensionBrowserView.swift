import ExtensionKit
import SwiftUI

@available(macOS 13.0, *)
public struct AppExtensionBrowserView: NSViewControllerRepresentable {
	public init() {
	}
	
	public func makeNSViewController(context: Context) -> EXAppExtensionBrowserViewController {
		return EXAppExtensionBrowserViewController()
	}

	public func updateNSViewController(_ viewController: EXAppExtensionBrowserViewController, context: Context) {
	}
}
