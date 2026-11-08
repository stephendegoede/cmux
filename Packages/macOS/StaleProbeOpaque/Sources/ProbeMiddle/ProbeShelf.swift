import ProbeCore

public struct ProbeShelf: Sendable {
    private let storedIDs: [String]

    public init(ids: [String]) {
        storedIDs = ids.map { ProbeDescriptor(id: $0).id }
    }

    public func ids() -> [String] {
        storedIDs
    }
}
