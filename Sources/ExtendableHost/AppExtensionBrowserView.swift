import ExtensionKit
import SwiftUI

#if os(macOS)
@available(macOS 13, *)
public struct AppExtensionBrowserView: NSViewControllerRepresentable {
	public init() {
	}

	public func makeNSViewController(context: Context) -> EXAppExtensionBrowserViewController {
		return EXAppExtensionBrowserViewController()
	}

	public func updateNSViewController(_ viewController: EXAppExtensionBrowserViewController, context: Context) {
	}
}
#else
@available(iOS 26, *)
public struct AppExtensionBrowserView: UIViewControllerRepresentable {
	public init() {
	}

	public func makeUIViewController(context: Context) -> EXAppExtensionBrowserViewController {
		return EXAppExtensionBrowserViewController()
	}

	public func updateUIViewController(_ viewController: EXAppExtensionBrowserViewController, context: Context) {
	}
}
#endif
