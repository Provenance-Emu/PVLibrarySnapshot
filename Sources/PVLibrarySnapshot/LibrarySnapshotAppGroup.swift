import Foundation

/// The App Group container the snapshot and its covers live in.
public struct LibrarySnapshotAppGroup: Sendable {
    public let configuration: LibrarySnapshotConfiguration

    public init(configuration: LibrarySnapshotConfiguration) {
        self.configuration = configuration
    }

    public var identifier: String { configuration.appGroupIdentifier }

    /// `nil` when the running process is not entitled to the group (unsigned CI
    /// build, wildcard profile, test process). Every caller must tolerate nil.
    public var containerURL: URL? {
        FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: identifier)
    }

    public var isAvailable: Bool { containerURL != nil }

    /// Shared suite, or nil when the group is unavailable. `UserDefaults(suiteName:)`
    /// itself never returns nil for a missing entitlement; it just silently fails to
    /// persist, which is why this is gated on `containerURL`.
    public var defaults: UserDefaults? {
        guard isAvailable else { return nil }
        return UserDefaults(suiteName: identifier)
    }

    public var mediaDirectory: URL? {
        containerURL?.appendingPathComponent(configuration.mediaSubpath, isDirectory: true)
    }

    public static func coverFilename(gameID: String) -> String { "cover_\(gameID).jpg" }

    public func coverURL(gameID: String) -> URL? {
        mediaDirectory?.appendingPathComponent(Self.coverFilename(gameID: gameID), isDirectory: false)
    }
}
