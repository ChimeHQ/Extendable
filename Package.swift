// swift-tools-version:5.5

import PackageDescription

let package = Package(
	name: "Extendable",
	products: [
		.library(name: "Extendable", targets: ["Extendable"]),
	],
	dependencies: [],
	targets: [
		.target(name: "Extendable", dependencies: []),
		.testTarget(name: "ExtendableTests", dependencies: ["Extendable"]),
	]
)
