import Testing
@testable import Listify

/// Tests for the `TemperatureListState` enum equality, which is used to decide
/// which KAN-1 screen (loading, data, empty, error) is rendered.
struct TemperatureListStateTests {

    @Test("loading equals loading")
    func loadingEquality() {
        #expect(TemperatureListState.loading == .loading)
    }

    @Test("empty equals empty")
    func emptyEquality() {
        #expect(TemperatureListState.empty == .empty)
    }

    @Test("error equality depends on the message")
    func errorEquality() {
        #expect(TemperatureListState.error("network") == .error("network"))
        #expect(TemperatureListState.error("network") != .error("timeout"))
    }

    @Test("loaded equality depends on the records")
    func loadedEquality() {
        let record = TemperatureRecord(id: .init(), year: 2001, month: "Jun", variance: 0.9)
        #expect(TemperatureListState.loaded([record]) == .loaded([record]))
        #expect(TemperatureListState.loaded([record]) != .loaded([]))
    }

    @Test("different cases are not equal")
    func distinctCases() {
        #expect(TemperatureListState.loading != .empty)
        #expect(TemperatureListState.empty != .error(""))
        #expect(TemperatureListState.loaded([]) != .empty)
    }
}
