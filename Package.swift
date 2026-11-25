// swift-tools-version:5.9
import Foundation
import PackageDescription

// A version tag resolves to the prebuilt XCFramework from that tag's GitHub release;
// `main` always builds from source. The release workflow fills this in on the tagged
// commit only, so it stays `nil` on every branch.
// Set PV_BUILD_FROM_SOURCE=1 to build a tagged version from source instead.
let binaryRelease: (version: String, checksums: [String: String])? = ("1.0.2", ["PVLibrarySnapshot": "e4094012bce49ed40bbd63e1767aa4e98c77d61f4e20f507cb72d365fa8aa095"])

let environment = ProcessInfo.processInfo.environment
let buildFromSource = binaryRelease == nil || environment["PV_BUILD_FROM_SOURCE"] != nil
// The release workflow builds the framework it publishes from a dynamic product.
let libraryType: Product.Library.LibraryType? = environment["PV_XCFRAMEWORK_BUILD"] != nil ? .dynamic : nil

let sourceTargets: [Target] = [
    // System frameworks only (Foundation, os, MetricKit where it exists). Linked by the app
    // AND by every extension, so it must never depend on the Dolphin core, UIKit, or
    // anything with a Realm/SwiftData store.
    .target(name: "PVLibrarySnapshot"),
    .testTarget(name: "PVLibrarySnapshotTests", dependencies: ["PVLibrarySnapshot"])
]

let binaryTargets: [Target] = binaryRelease.map { release in
    release.checksums.sorted { $0.key < $1.key }.map { module, checksum in
        .binaryTarget(
            name: module,
            url: "https://github.com/Provenance-Emu/PVLibrarySnapshot/releases/download/\(release.version)/\(module).xcframework.zip",
            checksum: checksum
        )
    }
} ?? []

let package = Package(
    name: "PVLibrarySnapshot",
    platforms: [.iOS(.v17), .tvOS(.v17), .macOS(.v14), .macCatalyst(.v17), .visionOS(.v1)],
    products: [
        .library(name: "PVLibrarySnapshot", type: buildFromSource ? libraryType : nil, targets: ["PVLibrarySnapshot"])
    ],
    targets: buildFromSource ? sourceTargets : binaryTargets
)
