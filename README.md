[![License][license badge]][license]

# Extendable
A set of utilities for more pleasant work with ExtensionKit

## Global Connection

Setting up an ExtensionKit extension can be confusing, and requires a fair amount of boilerplate. `ConnectableExtension` makes it easier to manage the global host connection.

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

## SwiftUI Wrappers

Extendable also includes a second library called `ExtendableViews`. You can its `AppExtensionBrowserView` and `ExtensionHostingView` to integrate the ExtensionKit view system with SwiftUI in your host application.

### Suggestions or Feedback

We'd love to hear from you! Get in touch via [twitter](https://twitter.com/chimehq), an issue, or a pull request.

Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.

[license]: https://opensource.org/licenses/BSD-3-Clause
[license badge]: https://img.shields.io/github/license/ChimeHQ/Extendable
