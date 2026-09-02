import Testing
import Foundation
@testable import Listify

/// Tests for `TemperatureListViewModel` state transitions and derived values,
/// which drive whether the KAN-1 screen shows the data list or the
/// no-data / error screen.
@MainActor
struct TemperatureListViewModelTests {

    // MARK: - Initial state

    @Test("defaults to loading state")
    func defaultsToLoading() {
        let viewModel = TemperatureListViewModel()
        #expect(viewModel.state == .loading)
        #expect(viewModel.records.isEmpty)
        #expect(viewModel.isCapturing == false)
    }

    @Test("can be constructed in an explicit initial state")
    func explicitInitialState() {
        let viewModel = TemperatureListViewModel(initialState: .empty)
        #expect(viewModel.state == .empty)
    }

    // MARK: - load()

    @Test("load() transitions to loaded with the sample records")
    func loadProducesLoadedState() async {
        let viewModel = TemperatureListViewModel()
        await viewModel.load()

        guard case let .loaded(records) = viewModel.state else {
            Issue.record("Expected .loaded, got \(viewModel.state)")
            return
        }
        #expect(records.count == TemperatureListViewModel.sampleRecords.count)
        #expect(records.isEmpty == false)
    }

    @Test("records accessor returns the loaded records after load()")
    func recordsAccessorAfterLoad() async {
        let viewModel = TemperatureListViewModel()
        await viewModel.load()
        #expect(viewModel.records.count == TemperatureListViewModel.sampleRecords.count)
        #expect(viewModel.records.first?.year == 1753)
        #expect(viewModel.records.first?.month == "Jan")
    }

    @Test("load() transitions to empty when the provider returns no records")
    func loadProducesEmptyState() async {
        let viewModel = TemperatureListViewModel(provider: { [] })
        await viewModel.load()
        #expect(viewModel.state == .empty)
        #expect(viewModel.records.isEmpty)
    }

    @Test("load() transitions to error when the provider throws")
    func loadProducesErrorState() async {
        struct LoadFailure: LocalizedError {
            var errorDescription: String? { "Could not reach the server" }
        }
        let viewModel = TemperatureListViewModel(provider: { throw LoadFailure() })
        await viewModel.load()

        guard case let .error(message) = viewModel.state else {
            Issue.record("Expected .error, got \(viewModel.state)")
            return
        }
        #expect(message == "Could not reach the server")
        #expect(viewModel.records.isEmpty)
    }

    @Test("load() uses the injected provider's records")
    func loadUsesInjectedProvider() async {
        let injected = [TemperatureRecord(year: 2020, month: "Aug", variance: 1.02)]
        let viewModel = TemperatureListViewModel(provider: { injected })
        await viewModel.load()
        #expect(viewModel.records.count == 1)
        #expect(viewModel.records.first?.year == 2020)
    }

    // MARK: - records accessor across states

    @Test("records accessor is empty in non-loaded states")
    func recordsEmptyInNonLoadedStates() {
        #expect(TemperatureListViewModel(initialState: .loading).records.isEmpty)
        #expect(TemperatureListViewModel(initialState: .empty).records.isEmpty)
        #expect(TemperatureListViewModel(initialState: .error("boom")).records.isEmpty)
    }

    @Test("records accessor reflects a loaded state")
    func recordsReflectLoadedState() {
        let records = [TemperatureRecord(year: 1999, month: "May", variance: 0.4)]
        let viewModel = TemperatureListViewModel(initialState: .loaded(records))
        #expect(viewModel.records.count == 1)
        #expect(viewModel.records.first?.year == 1999)
    }

    // MARK: - Capturing toggle

    @Test("isCapturing can be toggled")
    func capturingToggle() {
        let viewModel = TemperatureListViewModel()
        #expect(viewModel.isCapturing == false)
        viewModel.isCapturing = true
        #expect(viewModel.isCapturing == true)
    }

    // MARK: - Sample data integrity

    @Test("sample records are non-empty and well formed")
    func sampleDataIntegrity() {
        let samples = TemperatureListViewModel.sampleRecords
        #expect(samples.isEmpty == false)
        // All months are non-empty and years are plausible.
        for record in samples {
            #expect(record.month.isEmpty == false)
            #expect(record.year > 0)
        }
        // Ids are unique across the sample set.
        let uniqueIDs = Set(samples.map(\.id))
        #expect(uniqueIDs.count == samples.count)
    }
}
