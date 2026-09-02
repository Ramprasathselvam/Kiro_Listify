import Foundation

/// A single global temperature reading.
///
/// KAN-1 asks for a "global temperature list". Each record maps onto the fields
/// shown in the Figma list row: the year, the month, and the temperature
/// variance (anomaly) relative to a baseline.
struct TemperatureRecord: Identifiable, Hashable {
    let id: UUID
    /// Year of the reading, e.g. 1753.
    let year: Int
    /// Short month name, e.g. "Jan".
    let month: String
    /// Temperature variance / anomaly in degrees Celsius, e.g. -1.366.
    let variance: Double

    init(id: UUID = UUID(), year: Int, month: String, variance: Double) {
        self.id = id
        self.year = year
        self.month = month
        self.variance = variance
    }

    /// "Year: 1753"
    var yearText: String { "Year: \(year)" }

    /// "Month: Jan"
    var monthText: String { "Month: \(month)" }

    /// "variance: -1.366" (formatted to three decimal places).
    var varianceText: String {
        "variance: " + String(format: "%.3f", variance)
    }
}
