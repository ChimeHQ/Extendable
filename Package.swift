// swift-tools-version: 5.6

import PackageDescription

let package = Package(
	name: "Extendable",
	platforms: [.macOS(.v10_15)],
	products: [
		.library(name: "Extendable", targets: ["Extendable"]),
		.library(name: "ExtendableViews", targets: ["ExtendableViews"]),
	],
	dependencies: [],
	targets: [
		.target(name: "Extendable", dependencies: []),
		.target(name: "ExtendableViews", dependencies: []),
		.testTarget(name: "ExtendableTests", dependencies: ["Extendable"]),
	]
)
