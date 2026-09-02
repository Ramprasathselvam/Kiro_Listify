import SwiftUI

/// A single row in the temperature list (Figma `List_tripstory`).
///
/// Layout: a 70pt square thumbnail followed by a text column with the year,
/// month, and variance. The Figma thumbnail is a placeholder image; we render
/// a temperature SF Symbol so the app stays self-contained without bundling
/// remote assets.
struct TemperatureRow: View {
    let record: TemperatureRecord

    var body: some View {
        HStack(spacing: Theme.Spacing.x16) {
            thumbnail

            VStack(alignment: .leading, spacing: 2) {
                Text(record.yearText)
                    .font(Theme.Typography.h6)
                    .foregroundStyle(Theme.Colors.labelHighEmphasis)

                Text(record.monthText)
                    .font(Theme.Typography.h4)
                    .foregroundStyle(Theme.Colors.labelHighEmphasis)

                Text(record.varianceText)
                    .font(Theme.Typography.h6)
                    .foregroundStyle(Theme.Colors.labelMediumEmphasis)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(record.yearText), \(record.monthText), \(record.varianceText)")
    }

    private var thumbnail: some View {
        ZStack {
            Theme.Colors.illustrationBackground
            Image(systemName: "thermometer.medium")
                .font(.system(size: 34))
                .foregroundStyle(Theme.Colors.labelHighEmphasis)
        }
        .frame(width: 70, height: 70)
        .clipShape(RoundedRectangle(cornerRadius: 4))
    }
}

#Preview {
    VStack(spacing: 8) {
        TemperatureRow(record: TemperatureListViewModel.sampleRecords[0])
        Divider()
        TemperatureRow(record: TemperatureListViewModel.sampleRecords[1])
    }
    .padding()
}
