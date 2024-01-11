// swift-tools-version: 5.8

import PackageDescription

let settings: [SwiftSetting] = [
	.enableExperimentalFeature("StrictConcurrency")
]

let package = Package(
	name: "Extendable",
	platforms: [
		.macOS(.v11),
		.macCatalyst(.v14),
		.iOS(.v14),
		.watchOS(.v7),
		.tvOS(.v14)
	],
	products: [
		.library(name: "Extendable", targets: ["Extendable"]),
		.library(name: "ExtendableHost", targets: ["ExtendableHost"]),
	],
	dependencies: [],
	targets: [
		.target(name: "Extendable", swiftSettings: settings),
		.target(name: "ExtendableHost", swiftSettings: settings),
		.testTarget(name: "ExtendableTests", dependencies: ["Extendable"], swiftSettings: settings),
	]
)
