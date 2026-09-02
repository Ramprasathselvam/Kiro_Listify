import Foundation
import Observation

/// The loading state of the temperature list screen.
enum TemperatureListState: Equatable {
    case loading
    case loaded([TemperatureRecord])
    /// No data available — drives the empty-state screen.
    case empty
    /// Something went wrong — also drives the empty/error screen with an error message.
    case error(String)
}

/// Drives the temperature list screen. Loads the global temperature records and
/// exposes the current state so the view can render either the data list or the
/// no-data / error screen.
@Observable
@MainActor
final class TemperatureListViewModel {

    private(set) var state: TemperatureListState = .loading

    /// Reflects the "Start Capturing" toggle in the bottom navigation.
    var isCapturing: Bool = false

    /// Convenience accessor for the loaded records (empty when not loaded).
    var records: [TemperatureRecord] {
        if case let .loaded(records) = state { return records }
        return []
    }

    init(initialState: TemperatureListState = .loading) {
        self.state = initialState
    }

    /// Loads the temperature records.
    ///
    /// This currently serves in-memory sample data. It's structured as an async
    /// call so a real data source (network / persistence) can be dropped in later
    /// without changing the view layer.
    func load() async {
        state = .loading
        let data = Self.sampleRecords
        state = data.isEmpty ? .empty : .loaded(data)
    }

    // MARK: - Sample data

    static let sampleRecords: [TemperatureRecord] = [
        TemperatureRecord(year: 1753, month: "Jan", variance: -1.366),
        TemperatureRecord(year: 1753, month: "Feb", variance: -1.243),
        TemperatureRecord(year: 1753, month: "Mar", variance: -0.982),
        TemperatureRecord(year: 1754, month: "Jan", variance: -1.101),
        TemperatureRecord(year: 1754, month: "Feb", variance: -0.874),
        TemperatureRecord(year: 1755, month: "Jan", variance: -0.653)
    ]
}
