public struct ProbeDescriptor: Sendable {
    public let id: String

    public init(id: String, hint: String? = nil) {
        self.id = id
        _ = hint
    }
}
