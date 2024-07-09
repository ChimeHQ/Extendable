// swift-tools-version: 5.8

import PackageDescription

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
		.target(name: "Extendable"),
		.target(name: "ExtendableHost"),
		.testTarget(name: "ExtendableTests", dependencies: ["Extendable"]),
	]
)

let swiftSettings: [SwiftSetting] = [
	.enableExperimentalFeature("StrictConcurrency"),
]

for target in package.targets {
	var settings = target.swiftSettings ?? []
	settings.append(contentsOf: swiftSettings)
	target.swiftSettings = settings
}
