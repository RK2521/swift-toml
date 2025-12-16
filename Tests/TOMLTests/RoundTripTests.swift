import Foundation
import Testing

import TOML

@Suite("Round Trip Tests")
struct RoundTripTests {
    @Test func simpleObject() throws {
        struct Config: Codable, Equatable {
            let name: String
            let version: Int
            let debug: Bool
        }

        let original = Config(name: "MyApp", version: 42, debug: false)

        let encoder = TOMLEncoder()
        let encoded = try encoder.encode(original)

        let decoder = TOMLDecoder()
        let decoded = try decoder.decode(Config.self, from: encoded)

        #expect(original == decoded)
    }
}
