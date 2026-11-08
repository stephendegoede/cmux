import ProbeCore
import ProbeMiddle
import Testing

struct ProbeShelfTests {
    @Test func shelfKeepsDescriptorIDs() {
        let shelf = ProbeShelf(items: [ProbeDescriptor(id: "a"), ProbeDescriptor(id: "b")])
        #expect(shelf.ids() == ["a", "b"])
    }
}
