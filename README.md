# Extendable
A set of utilities for more pleasant work with ExtensionKit

## Simpler NSXPCConnection management

Setting up an ExtensionKit extension can be confusing, and requires a fair amount of boilerplate. Check out `ConnectableExtension`:

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

Dealing with View-based extensions is even more complex. And, there isn't a clear way to get access to the host connection in your views. `ConnectableSceneExtension` makes this way simpler.

```swift
@main
final class ViewExtension: ConnectableSceneExtension {
    init() {
    }

    func acceptConnection(_ connection: NSXPCConnection) throws {
        // handle global connection
    }
    
    func scene(for id: String, connection: NSXPCConnection?) throws -> Body
        // optionally handle per-view connection
        return ConnectionView(connection: connection)
    }
}

struct ConnectionView: View {
    let connection: NSXPCConnection?

    var value: String {
        return String(describing: connection)
    }

    var body: some View {
        VStack {
            Rectangle().frame(width: nil, height: 4).foregroundColor(.green)
            Spacer()
            Text("hmmm: \(value)")
            Spacer()
            Rectangle().frame(width: nil, height: 4).foregroundColor(.red)
        }
    }
}
```

Note that `ConnectableSceneExtension` is designed to support mulitple scene ids. But, as of Ventura Beta 6, I am not able to determine how you configure an extension for more than one scene.

## SwiftUI Wrappers

You can use `AppExtensionBrowserView` and `ExtensionHostingView` to integrate the ExtensionKit view system with SwiftUI. Neither are complicated, but nice to have. These are within a seperate "ExtendableViews" library.

### Suggestions or Feedback

We'd love to hear from you! Get in touch via [twitter](https://twitter.com/chimehq), an issue, or a pull request.

Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.
