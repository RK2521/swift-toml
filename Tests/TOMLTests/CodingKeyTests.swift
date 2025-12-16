import Testing

@testable import TOML

@Suite("CodingKey Tests")
struct CodingKeyTests {
    @Test func createWithStringValue() {
        let key = TOMLCodingKey(stringValue: "test")
        #expect(key.stringValue == "test")
        #expect(key.intValue == nil)
    }

    @Test func createWithIntValue() {
        let key = TOMLCodingKey(intValue: 123)
        #expect(key.stringValue == "123")
        #expect(key.intValue == 123)
    }

    @Test func createWithIndex() {
        let key = TOMLCodingKey(index: 123)
        #expect(key.stringValue == "Index 123")
        #expect(key.intValue == 123)
    }
}
