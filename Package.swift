// swift-tools-version:5.5

import PackageDescription

let package = Package(
	name: "Extendable",
	platforms: [.macOS(.v11), .iOS(.v14), .watchOS(.v7), .tvOS(.v14)],
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
