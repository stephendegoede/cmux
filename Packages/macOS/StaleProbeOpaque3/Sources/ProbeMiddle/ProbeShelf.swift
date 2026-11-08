import ProbeCore

// Uses nothing of ProbeCore, so a change to ProbeCore leaves this module's bytes as they are (the shape of
// CmuxNextPalette, which CmuxNextPaletteTests depends on, and CmuxNextActions' ActionDescriptor.init).
public struct ProbeShelf: Sendable {
    private let storedIDs: [String]
    public init(ids: [String]) { storedIDs = ids }
    public func ids() -> [String] { storedIDs }
}
