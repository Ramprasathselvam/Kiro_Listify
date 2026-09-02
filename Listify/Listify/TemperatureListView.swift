import SwiftUI

/// The global temperature list screen (KAN-1).
///
/// Composes the top navigation bar, a state-driven content area (loading, data
/// list, or no-data / error), and the bottom capturing toggle. Matches the
/// Figma `1050_tripstories_list` and `1050_tripstories_emptyview` frames.
struct TemperatureListView: View {
    @State private var viewModel = TemperatureListViewModel()

    /// Whether the screen was pushed onto a navigation stack. Drives the back
    /// button independently of the load state so nav chrome doesn't flicker
    /// while data loads.
    var showsBackButton: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            TopBar(
                title: "Trip Stories",
                showsBackButton: showsBackButton,
                isSelectEnabled: canSelect
            )

            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            BottomToggleBar(isOn: $viewModel.isCapturing)
        }
        .background(Theme.Colors.surface)
        .task {
            await viewModel.load()
        }
    }

    /// "Select" is only actionable when there are records to select.
    private var canSelect: Bool {
        if case .loaded = viewModel.state { return true }
        return false
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        case let .loaded(records):
            list(records)

        case .empty:
            EmptyStateView()

        case let .error(message):
            EmptyStateView(
                headline: "Something went wrong",
                message: message
            )
        }
    }

    private func list(_ records: [TemperatureRecord]) -> some View {
        ScrollView {
            LazyVStack(spacing: Theme.Spacing.x8) {
                ForEach(Array(records.enumerated()), id: \.element.id) { index, record in
                    TemperatureRow(record: record)
                    // Divider between rows only — not after the last one.
                    if index < records.count - 1 {
                        Divider()
                            .overlay(Theme.Colors.divider)
                    }
                }
            }
            .padding(Theme.Spacing.x16)
        }
    }
}

#Preview("Data") {
    TemperatureListView()
}

#Preview("Empty") {
    StatePreview(state: .empty)
}

#Preview("Error") {
    StatePreview(state: .error("We couldn't load the temperature data. Pull to try again."))
}

/// Helper preview that renders the screen in a fixed state without loading.
private struct StatePreview: View {
    let state: TemperatureListState

    var body: some View {
        VStack(spacing: 0) {
            TopBar(title: "Trip Stories", showsBackButton: false, isSelectEnabled: false)
            switch state {
            case .empty:
                EmptyStateView()
            case let .error(message):
                EmptyStateView(headline: "Something went wrong", message: message)
            default:
                EmptyStateView()
            }
            BottomToggleBar(isOn: .constant(false))
        }
    }
}
