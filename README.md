# PVLibrarySnapshot

A small JSON snapshot of an emulator app's library, written by the app into its App Group and
read by its extensions: widgets, Top Shelf, Quick Look, Spotlight and thumbnails. It includes:

- the snapshot model, with recently played, favorites, recently added and every game by id;
- the store, with a load outcome that says why a snapshot is empty;
- `ExtensionTelemetry` signposts and the MetricKit `ExtensionMetricsReport`;
- `PreviewFormatting` helpers.

It's shared by iCube and Provenance.

```swift
.package(url: "https://github.com/Provenance-Emu/PVLibrarySnapshot.git", .upToNextMajor(from: "1.0.0"))
```

The app and each of its extensions build the same configuration:

```swift
let config = LibrarySnapshotConfiguration(
    appGroupIdentifier: "group.com.example.app",
    launchURLScheme: "exampleapp",          // <scheme>://play?id=<game id>
    telemetrySubsystem: "com.example.app"
)
let group = LibrarySnapshotAppGroup(configuration: config)
let store = LibrarySnapshotStore(appGroup: group)
let url = game.launchURL(using: config)
let cover = game.coverURL(in: group)
let telemetry = ExtensionTelemetry(.widget, subsystem: config.telemetrySubsystem)
```

`LibrarySnapshotGame.platform` is a string, so each app keeps its own platform or system type.
Disc and header readers and per-app lookups also stay in the app.

Extracted with history on 2026-10-17 from iCube's `Source/iOS/PVLibrarySnapshot`
(Provenance-Emu/iCube `093cefdccc`). iCube's `DiscHeaderReader`, `LibraryLookup`,
`LibraryPlatform` and `RecentGamesWidgetKind` moved back into iCube.
