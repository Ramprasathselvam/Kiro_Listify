import Testing
import Foundation
@testable import Listify

/// Tests for the `TemperatureRecord` model and its display formatting,
/// which back the KAN-1 list row (Year / Month / variance).
struct TemperatureRecordTests {

    @Test("yearText formats as 'Year: <year>'")
    func yearText() {
        let record = TemperatureRecord(year: 1753, month: "Jan", variance: -1.366)
        #expect(record.yearText == "Year: 1753")
    }

    @Test("monthText formats as 'Month: <month>'")
    func monthText() {
        let record = TemperatureRecord(year: 1753, month: "Jan", variance: -1.366)
        #expect(record.monthText == "Month: Jan")
    }

    @Test("varianceText formats to three decimal places")
    func varianceTextThreeDecimals() {
        let record = TemperatureRecord(year: 1753, month: "Jan", variance: -1.366)
        #expect(record.varianceText == "variance: -1.366")
    }

    @Test("varianceText pads and rounds to three decimals")
    func varianceTextRounding() {
        #expect(TemperatureRecord(year: 2000, month: "Jul", variance: 1.5).varianceText == "variance: 1.500")
        #expect(TemperatureRecord(year: 2000, month: "Jul", variance: 0).varianceText == "variance: 0.000")
        // 0.12349 rounds to 0.123 at three decimals.
        #expect(TemperatureRecord(year: 2000, month: "Jul", variance: 0.12349).varianceText == "variance: 0.123")
    }

    @Test("records with different ids are not equal even with identical values")
    func identityDistinguishesRecords() {
        let a = TemperatureRecord(year: 1753, month: "Jan", variance: -1.366)
        let b = TemperatureRecord(year: 1753, month: "Jan", variance: -1.366)
        #expect(a != b)
        #expect(a.id != b.id)
    }

    @Test("a record equals itself and hashes consistently")
    func equalityAndHashing() {
        let id = UUID()
        let a = TemperatureRecord(id: id, year: 1900, month: "Dec", variance: 0.25)
        let b = TemperatureRecord(id: id, year: 1900, month: "Dec", variance: 0.25)
        #expect(a == b)
        #expect(a.hashValue == b.hashValue)
    }

    @Test("default initializer assigns a unique id")
    func defaultInitializerAssignsID() {
        let record = TemperatureRecord(year: 1800, month: "Mar", variance: -0.5)
        #expect(record.year == 1800)
        #expect(record.month == "Mar")
        #expect(record.variance == -0.5)
    }
}
