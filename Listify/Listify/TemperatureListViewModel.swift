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

/// Asynchronously produces the temperature records for the list.
///
/// Injecting this lets the view model reach every state: a thrown error maps to
/// `.error`, an empty result maps to `.empty`, and a non-empty result maps to
/// `.loaded`. The default provider serves in-memory sample data; a real
/// network / persistence source can be substituted without touching the view.
typealias TemperatureRecordProvider = @Sendable () async throws -> [TemperatureRecord]

/// Drives the temperature list screen. Loads the global temperature records and
/// exposes the current state so the view can render either the data list or the
/// no-data / error screen.
@Observable
@MainActor
final class TemperatureListViewModel {

    private(set) var state: TemperatureListState = .loading

    /// Reflects the "Start Capturing" toggle in the bottom navigation.
    var isCapturing: Bool = false

    /// The data source used by `load()`.
    private let provider: TemperatureRecordProvider

    /// Convenience accessor for the loaded records (empty when not loaded).
    var records: [TemperatureRecord] {
        if case let .loaded(records) = state { return records }
        return []
    }

    /// Creates a view model.
    /// - Parameters:
    ///   - initialState: The state to start in (defaults to `.loading`).
    ///   - provider: The async source of records used by `load()`. Defaults to
    ///     the in-memory sample data.
    init(
        initialState: TemperatureListState = .loading,
        provider: @escaping TemperatureRecordProvider = { TemperatureListViewModel.sampleRecords }
    ) {
        self.state = initialState
        self.provider = provider
    }

    /// Loads the temperature records from the injected provider.
    ///
    /// Maps the outcome to a state:
    /// - a thrown error → `.error`
    /// - an empty result → `.empty`
    /// - a non-empty result → `.loaded`
    func load() async {
        state = .loading
        do {
            let data = try await provider()
            state = data.isEmpty ? .empty : .loaded(data)
        } catch {
            state = .error(error.localizedDescription)
        }
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
