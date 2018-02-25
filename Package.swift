import PackageDescription

let package = Package(
	name: "Blockchain",
	targets: [],
	dependencies: [
		.Package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", majorVersion: 3),
        .Package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", majorVersion: 0),
	]
)
