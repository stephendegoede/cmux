import ProbeCore
import ProbeMiddle
import Testing

struct ProbeShelfTests {
    @Test func shelfKeepsDescriptorIDs() {
        let descriptors = [ProbeDescriptor(id: "a"), ProbeDescriptor(id: "b")]
        let shelf = ProbeShelf(ids: descriptors.map(\.id))
        #expect(shelf.ids() == ["a", "b"])
    }
}
