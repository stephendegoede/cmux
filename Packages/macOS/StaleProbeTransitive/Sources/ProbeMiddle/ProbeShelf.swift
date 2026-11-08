import ProbeCore

public struct ProbeShelf: Sendable {
    public let items: [ProbeDescriptor]

    public init(items: [ProbeDescriptor]) {
        self.items = items
    }

    public func ids() -> [String] {
        items.map(\.id)
    }
}
