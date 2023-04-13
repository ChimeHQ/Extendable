// swift-tools-version:5.5

import PackageDescription

let package = Package(
	name: "Extendable",
	platforms: [.macOS(.v11), .iOS(.v14), .watchOS(.v7), .tvOS(.v14)],
	products: [
		.library(name: "Extendable", targets: ["Extendable"]),
		.library(name: "ExtendableHost", targets: ["ExtendableHost"]),
	],
	dependencies: [],
	targets: [
		.target(name: "Extendable", dependencies: []),
		.target(name: "ExtendableHost", dependencies: []),
		.testTarget(name: "ExtendableTests", dependencies: ["Extendable"]),
	]
)
