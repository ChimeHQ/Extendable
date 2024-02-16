import Foundation

// from https://forums.swift.org/t/complete-checking-with-an-incorrectly-annotated-init-conformance/69955/7

/// Used to initialize properties for non-isolated init conformance.
///
/// Will be obseleted by SE-0414
@propertyWrapper
public struct InitializerTransferred<Value>: @unchecked Sendable {
	public let wrappedValue: Value

	public init(_ wrappedValue: Value) {
		self.wrappedValue = wrappedValue
	}

	public init(mainActorProvider: @MainActor () -> Value) {
		self.wrappedValue = MainActor.assumeIsolated {
			mainActorProvider()
		}
	}
}
