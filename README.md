<div align="center">

[![Build Status][build status badge]][build status]
[![Platforms][platforms badge]][platforms]
[![Documentation][documentation badge]][documentation]
[![Matrix][matrix badge]][matrix]

</div>

# Extendable
A set of utilities for more pleasant work with [ExtensionKit](https://developer.apple.com/documentation/extensionkit).

ExtensionKit and ExtensionFoundation provide a system for inter-app communcation and operation. They are very cool! For a long time, these frameworks were only functional on macOS, but it looks like they are now supported on other Apple platforms, including iOS. Pretty much everything here has only been tested on macOS, but I'll get to it!

The package is split into two parts. Most of the interesting stuff is on the extension-side. But, there are some handy things for hosting extensions as well. There is also a macOS/iOS example project if you want to check out how everything fits together. There's another [example](https://github.com/KhaosT/UIExtensionExample) that doesn't use this library.

If you are here, two other packages you might like are [AsyncXPCConnection](https://github.com/ChimeHQ/AsyncXPCConnection) and [XPCConnectionSession](https://github.com/ChimeHQ/XPCConnectionSession).

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/ChimeHQ/Extendable", from: "0.1.0")
],
targets: [
    .target(
        name: "ExtensionSide",
        dependencies: ["Extendable"]
    ),
    .target(
        name: "HostSide",
        dependencies: [.product(name: "ExtendableHost", package: "Extendable")]
    ),
]
```

## Global Connection

Setting up an ExtensionKit extension can be confusing and requires a fair amount of boilerplate. `ConnectableExtension` makes it easier to manage the global host connection.

```swift
@main
final class ExampleExtension: ConnectableExtension {
    init() {
    }

    func acceptConnection(_ connection: NSXPCConnection) throws {
        // configure your global connection and possibly
        // store references to host interface objects
    }
}
```

## Scenes

Dealing with View-based extensions is even more complex. And, there isn't a clear way to get access to the host connection in your views. Extendable comes with a few components that make it easier to build scenes and manage view connections.

### ConnectingAppExtensionScene

This is a `AppExtensionScene` that makes it easier to get access to the scene's connection within your `View`.

```swift
ConnectingAppExtensionScene(sceneID: "one") { (sceneId, connection) in
    try ConnectionView(sceneId: sceneId, connection: connection)
}
```

### AppExtensionSceneGroup

I expect this type won't be needed once Ventura ships. And, maybe it's just me, but I've been unable to figure out how to use `AppExtensionSceneBuilder` without a wrapper type. So here it is.

(me three years later, lol)

### Example View

You can use `ConnectingAppExtensionScene` and `AppExtensionSceneGroup` independently, or as part of a more standard extension structure. But, if you want, you can also make use of the `ConnectableSceneExtension` protocol to really streamline your view class. Here's a full example:

```swift
@main
final class ViewExtension: ConnectableSceneExtension {
    init() {
    }

    func acceptConnection(_ connection: NSXPCConnection) throws {
        // handle global connection
    }
    
    var scene: some AppExtensionScene {
        AppExtensionSceneGroup {
            ConnectingAppExtensionScene(sceneID: "one") { (sceneId, connection) in
                try ConnectionView(sceneId: sceneId, connection: connection)
            }
            ConnectingAppExtensionScene(sceneID: "two") { (sceneId, connection) in
                try ConnectionView(sceneId: sceneId, connection: connection)
            }
        }
    }
}

struct ConnectionView: View {
    let sceneName: String
    let connection: NSXPCConnection?

    init(sceneId: String, connection: NSXPCConnection?) throws {
        self.sceneName = sceneId
        self.connection = connection
    }

    var value: String {
        return String(describing: connection)
    }

    var body: some View {
        VStack {
            Rectangle().frame(width: nil, height: 4).foregroundColor(.green)
            Spacer()
            Text("\(sceneName): \(value)")
            Spacer()
            Rectangle().frame(width: nil, height: 4).foregroundColor(.red)
        }
    }
}
```

## ExtendableHost

Extendable also includes a second library called `ExtendableHost`.

You can its `AppExtensionBrowserView` and `ExtensionHostingView` to integrate the ExtensionKit view system with SwiftUI in your host application.

It also includes the `AppExtensionMonitor` type. This is a cross-platform `Observable` that wraps `AppExtensionPoint.Monitor` when available, but falls back to `AppExtensionIdentity.matching` for older versions of macOS.

```swift
// very simple init extension to help with actor-isolation compatibility
let process = try await AppExtensionProcess(appExtensionIdentity: identity)
```

## Contributing and Collaboration

I would love to hear from you! Issues or pull requests work great. A [Matrix space][matrix] is also available for live help, but I have a strong bias towards answering in the form of documentation.

I prefer collaboration, and would love to find ways to work together if you have a similar project.

I prefer indentation with tabs for improved accessibility. But, I'd rather you use the system you want and make a PR than hesitate because of whitespace.

By participating in this project you agree to abide by the [Contributor Code of Conduct](CODE_OF_CONDUCT.md).

[build status]: https://github.com/ChimeHQ/Extendable/actions
[build status badge]: https://github.com/ChimeHQ/Extendable/workflows/CI/badge.svg
[platforms]: https://swiftpackageindex.com/ChimeHQ/Extendable
[platforms badge]: https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FChimeHQ%2FExtendable%2Fbadge%3Ftype%3Dplatforms
[documentation]: https://swiftpackageindex.com/ChimeHQ/Extendable/main/documentation
[documentation badge]: https://img.shields.io/badge/Documentation-DocC-blue
[matrix]: https://matrix.to/#/%23chimehq%3Amatrix.org
[matrix badge]: https://img.shields.io/matrix/chimehq%3Amatrix.org?label=Matrix
