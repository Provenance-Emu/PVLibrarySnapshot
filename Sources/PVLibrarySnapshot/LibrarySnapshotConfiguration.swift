import Foundation

/// The per-app settings for the library snapshot shared with an app's
/// extensions (widgets, Top Shelf, Quick Look, Spotlight). The app and every
/// extension build the same one; nothing app-specific is baked into the package.
///
/// ```swift
/// let snapshot = LibrarySnapshotConfiguration(
///     appGroupIdentifier: "group.com.joemattiello.icube",
///     launchURLScheme: "dolphinios",
///     telemetrySubsystem: "com.joemattiello.iCube"
/// )
/// let store = LibrarySnapshotStore(appGroup: LibrarySnapshotAppGroup(configuration: snapshot))
/// ```
public struct LibrarySnapshotConfiguration: Sendable, Equatable {
    /// The App Group the app and its extensions share.
    public var appGroupIdentifier: String
    /// Scheme of the "launch this game" URL (`<scheme>://<host>?<queryItem>=<id>`).
    public var launchURLScheme: String
    public var launchURLHost: String
    public var launchURLQueryItem: String
    /// Where covers live inside the group container. tvOS only allows writes
    /// under Library/Caches inside a group container, so the default uses that.
    public var mediaSubpath: String
    /// os_log subsystem for `ExtensionTelemetry`.
    public var telemetrySubsystem: String

    public init(
        appGroupIdentifier: String,
        launchURLScheme: String,
        launchURLHost: String = "play",
        launchURLQueryItem: String = "id",
        mediaSubpath: String = "Library/Caches/LibraryMedia",
        telemetrySubsystem: String
    ) {
        self.appGroupIdentifier = appGroupIdentifier
        self.launchURLScheme = launchURLScheme
        self.launchURLHost = launchURLHost
        self.launchURLQueryItem = launchURLQueryItem
        self.mediaSubpath = mediaSubpath
        self.telemetrySubsystem = telemetrySubsystem
    }
}
