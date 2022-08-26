# Extendable
A set of utilities for more pleasant work with ExtensionKit

## Simpler NSXPCConnection management

By default, ExtensionKit demands quite a bit of boilerplate code, which also imposes a number of invalid states you have to manage. `ConnectableExtension` defines a protocol with a much simpler interface.

```swift
final class MyExtension: ConnectableExtension {
	init(connection: NSXPCConnection) throws {
		// Do your connection config here
		throw ConnectableExtensionError.connectionUnsupported
	}
}

And now, you can set up an extension with just like this:

```swift
@main
final class ExampleExtension: AppExtension {
	let wrapper = ConnectingExtension<MyExtension>()

	public var configuration: some AppExtensionConfiguration {
		return wrapper.configuration
	}
}
```

### Suggestions or Feedback

We'd love to hear from you! Get in touch via [twitter](https://twitter.com/chimehq), an issue, or a pull request.

Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.
