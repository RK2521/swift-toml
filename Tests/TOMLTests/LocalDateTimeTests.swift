import Testing
import Foundation

import TOML

@Suite("LocalDateTime Tests")
struct LocalDateTimeTests {
    @Test func initialization() {
        let dt = LocalDateTime(year: 2024, month: 1, day: 15, hour: 9, minute: 30, second: 45, nanosecond: 123456789)

        #expect(dt.year == 2024)
        #expect(dt.month == 1)
        #expect(dt.day == 15)
        #expect(dt.hour == 9)
        #expect(dt.minute == 30)
        #expect(dt.second == 45)
        #expect(dt.nanosecond == 123456789)
    }

    @Test func initializationWithDefaultNanosecond() {
        let dt = LocalDateTime(year: 2024, month: 6, day: 20, hour: 12, minute: 0, second: 0)

        #expect(dt.nanosecond == 0)
    }

    @Test func equatable() {
        let dt1 = LocalDateTime(year: 2024, month: 1, day: 15, hour: 9, minute: 30, second: 0)
        let dt2 = LocalDateTime(year: 2024, month: 1, day: 15, hour: 9, minute: 30, second: 0)
        let dt3 = LocalDateTime(year: 2024, month: 1, day: 15, hour: 9, minute: 31, second: 0)

        #expect(dt1 == dt2)
        #expect(dt1 != dt3)
    }

    @Test func hashable() {
        let dt1 = LocalDateTime(year: 2024, month: 1, day: 15, hour: 9, minute: 30, second: 0)
        let dt2 = LocalDateTime(year: 2024, month: 1, day: 15, hour: 9, minute: 30, second: 0)

        var set = Set<LocalDateTime>()
        set.insert(dt1)
        set.insert(dt2)

        #expect(set.count == 1)
    }

    @Test func decodeFromTOML() throws {
        let toml = """
            created = 2024-01-15T09:30:00
            updated = 2024-12-31T23:59:59
            """

        struct Config: Codable {
            let created: LocalDateTime
            let updated: LocalDateTime
        }

        let decoder = TOMLDecoder()
        let config = try decoder.decode(Config.self, from: toml)

        #expect(config.created.year == 2024)
        #expect(config.created.month == 1)
        #expect(config.created.day == 15)
        #expect(config.created.hour == 9)
        #expect(config.created.minute == 30)
        #expect(config.created.second == 0)

        #expect(config.updated.year == 2024)
        #expect(config.updated.month == 12)
        #expect(config.updated.day == 31)
        #expect(config.updated.hour == 23)
        #expect(config.updated.minute == 59)
        #expect(config.updated.second == 59)
    }

    @Test func decodeWithFractionalSeconds() throws {
        let toml = """
            timestamp = 2024-01-15T09:30:00.123456789
            """

        struct Config: Codable {
            let timestamp: LocalDateTime
        }

        let decoder = TOMLDecoder()
        let config = try decoder.decode(Config.self, from: toml)

        #expect(config.timestamp.nanosecond == 123456789)
    }

    @Test func encodeToTOML() throws {
        struct Config: Codable {
            let timestamp: LocalDateTime
        }

        let config = Config(timestamp: LocalDateTime(year: 2024, month: 1, day: 15, hour: 9, minute: 30, second: 45))
        let encoder = TOMLEncoder()
        let toml = try encoder.encodeToString(config)

        #expect(toml.contains("2024-01-15T09:30:45") || toml.contains("2024-01-15 09:30:45"))
    }

    @Test func roundTrip() throws {
        struct Config: Codable, Equatable {
            let timestamp: LocalDateTime
        }

        let original = Config(timestamp: LocalDateTime(year: 2024, month: 6, day: 15, hour: 14, minute: 30, second: 0))

        let encoder = TOMLEncoder()
        let encoded = try encoder.encode(original)

        let decoder = TOMLDecoder()
        let decoded = try decoder.decode(Config.self, from: encoded)

        #expect(original == decoded)
    }
}

@Suite("LocalDate Tests")
struct LocalDateTests {
    @Test func initialization() {
        let date = LocalDate(year: 2024, month: 5, day: 15)

        #expect(date.year == 2024)
        #expect(date.month == 5)
        #expect(date.day == 15)
    }

    @Test func equatable() {
        let date1 = LocalDate(year: 2024, month: 5, day: 15)
        let date2 = LocalDate(year: 2024, month: 5, day: 15)
        let date3 = LocalDate(year: 2024, month: 5, day: 16)

        #expect(date1 == date2)
        #expect(date1 != date3)
    }

    @Test func hashable() {
        let date1 = LocalDate(year: 2024, month: 5, day: 15)
        let date2 = LocalDate(year: 2024, month: 5, day: 15)

        var set = Set<LocalDate>()
        set.insert(date1)
        set.insert(date2)

        #expect(set.count == 1)
    }

    @Test func decodeFromTOML() throws {
        let toml = """
            birthday = 1990-05-15
            anniversary = 2020-12-25
            """

        struct Config: Codable {
            let birthday: LocalDate
            let anniversary: LocalDate
        }

        let decoder = TOMLDecoder()
        let config = try decoder.decode(Config.self, from: toml)

        #expect(config.birthday.year == 1990)
        #expect(config.birthday.month == 5)
        #expect(config.birthday.day == 15)

        #expect(config.anniversary.year == 2020)
        #expect(config.anniversary.month == 12)
        #expect(config.anniversary.day == 25)
    }

    @Test func encodeToTOML() throws {
        struct Config: Codable {
            let date: LocalDate
        }

        let config = Config(date: LocalDate(year: 2024, month: 1, day: 15))
        let encoder = TOMLEncoder()
        let toml = try encoder.encodeToString(config)

        #expect(toml.contains("2024-01-15"))
    }

    @Test func roundTrip() throws {
        struct Config: Codable, Equatable {
            let date: LocalDate
        }

        let original = Config(date: LocalDate(year: 2024, month: 6, day: 15))

        let encoder = TOMLEncoder()
        let encoded = try encoder.encode(original)

        let decoder = TOMLDecoder()
        let decoded = try decoder.decode(Config.self, from: encoded)

        #expect(original == decoded)
    }

    @Test func boundaryValues() throws {
        let toml = """
            start = 0001-01-01
            leap = 2024-02-29
            endOfYear = 2024-12-31
            """

        struct Config: Codable {
            let start: LocalDate
            let leap: LocalDate
            let endOfYear: LocalDate
        }

        let decoder = TOMLDecoder()
        let config = try decoder.decode(Config.self, from: toml)

        #expect(config.start.year == 1)
        #expect(config.start.month == 1)
        #expect(config.start.day == 1)

        #expect(config.leap.month == 2)
        #expect(config.leap.day == 29)

        #expect(config.endOfYear.month == 12)
        #expect(config.endOfYear.day == 31)
    }
}

@Suite("LocalTime Tests")
struct LocalTimeTests {
    @Test func initialization() {
        let time = LocalTime(hour: 14, minute: 30, second: 45, nanosecond: 123456789)

        #expect(time.hour == 14)
        #expect(time.minute == 30)
        #expect(time.second == 45)
        #expect(time.nanosecond == 123456789)
    }

    @Test func initializationWithDefaultNanosecond() {
        let time = LocalTime(hour: 12, minute: 0, second: 0)

        #expect(time.nanosecond == 0)
    }

    @Test func equatable() {
        let time1 = LocalTime(hour: 14, minute: 30, second: 0)
        let time2 = LocalTime(hour: 14, minute: 30, second: 0)
        let time3 = LocalTime(hour: 14, minute: 31, second: 0)

        #expect(time1 == time2)
        #expect(time1 != time3)
    }

    @Test func hashable() {
        let time1 = LocalTime(hour: 14, minute: 30, second: 0)
        let time2 = LocalTime(hour: 14, minute: 30, second: 0)

        var set = Set<LocalTime>()
        set.insert(time1)
        set.insert(time2)

        #expect(set.count == 1)
    }

    @Test func decodeFromTOML() throws {
        let toml = """
            alarm = 07:30:00
            meeting = 14:00:00
            """

        struct Config: Codable {
            let alarm: LocalTime
            let meeting: LocalTime
        }

        let decoder = TOMLDecoder()
        let config = try decoder.decode(Config.self, from: toml)

        #expect(config.alarm.hour == 7)
        #expect(config.alarm.minute == 30)
        #expect(config.alarm.second == 0)

        #expect(config.meeting.hour == 14)
        #expect(config.meeting.minute == 0)
        #expect(config.meeting.second == 0)
    }

    @Test func decodeWithFractionalSeconds() throws {
        let toml = """
            precise = 12:30:45.123456789
            """

        struct Config: Codable {
            let precise: LocalTime
        }

        let decoder = TOMLDecoder()
        let config = try decoder.decode(Config.self, from: toml)

        #expect(config.precise.hour == 12)
        #expect(config.precise.minute == 30)
        #expect(config.precise.second == 45)
        #expect(config.precise.nanosecond == 123456789)
    }

    @Test func encodeToTOML() throws {
        struct Config: Codable {
            let time: LocalTime
        }

        let config = Config(time: LocalTime(hour: 14, minute: 30, second: 45))
        let encoder = TOMLEncoder()
        let toml = try encoder.encodeToString(config)

        #expect(toml.contains("14:30:45"))
    }

    @Test func roundTrip() throws {
        struct Config: Codable, Equatable {
            let time: LocalTime
        }

        let original = Config(time: LocalTime(hour: 14, minute: 30, second: 0))

        let encoder = TOMLEncoder()
        let encoded = try encoder.encode(original)

        let decoder = TOMLDecoder()
        let decoded = try decoder.decode(Config.self, from: encoded)

        #expect(original == decoded)
    }

    @Test func boundaryValues() throws {
        let toml = """
            midnight = 00:00:00
            endOfDay = 23:59:59
            """

        struct Config: Codable {
            let midnight: LocalTime
            let endOfDay: LocalTime
        }

        let decoder = TOMLDecoder()
        let config = try decoder.decode(Config.self, from: toml)

        #expect(config.midnight.hour == 0)
        #expect(config.midnight.minute == 0)
        #expect(config.midnight.second == 0)

        #expect(config.endOfDay.hour == 23)
        #expect(config.endOfDay.minute == 59)
        #expect(config.endOfDay.second == 59)
    }
}
