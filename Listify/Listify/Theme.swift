import SwiftUI

/// Design tokens extracted from the Figma design (file cE0IcdNMzZ0dM7mKHsY7iB).
/// Centralizes colors, spacing, and typography so the UI stays consistent with the design system.
enum Theme {

    // MARK: - Colors

    enum Colors {
        /// Base surface / page background — `elevation/elevation00`.
        static let surface = Color.white
        /// Navigation bar surface — `elevation/elevation03`.
        static let surfaceElevated = Color.white

        /// `label/high-emphasis` — rgba(0, 0, 0, 0.87).
        static let labelHighEmphasis = Color.black.opacity(0.87)
        /// `label/medium-emphasis` — rgba(0, 0, 0, 0.54).
        static let labelMediumEmphasis = Color.black.opacity(0.54)
        /// `label/disabled` — rgba(0, 0, 0, 0.2).
        static let labelDisabled = Color.black.opacity(0.2)

        /// `primary/primary` — #0073BF.
        static let primary = Color(red: 0 / 255, green: 115 / 255, blue: 191 / 255)

        /// Divider hairline color.
        static let divider = Color.black.opacity(0.08)

        /// Neutral tone used by the empty-state illustration.
        static let illustration = Color(red: 0x9E / 255, green: 0xA6 / 255, blue: 0xAD / 255)
        static let illustrationBackground = Color(red: 0xF0 / 255, green: 0xF2 / 255, blue: 0xF3 / 255)
    }

    // MARK: - Spacing (matches Figma spacing scale)

    enum Spacing {
        static let none: CGFloat = 0
        static let x4: CGFloat = 4
        static let x8: CGFloat = 8
        static let x16: CGFloat = 16
        static let x24: CGFloat = 24
        static let x32: CGFloat = 32
    }

    // MARK: - Typography
    //
    // Line height in the design is 1.3; SwiftUI does not expose a direct multiplier,
    // so we approximate with system fonts at the specified sizes/weights.

    enum Typography {
        /// H2 — 18pt regular. Used for the empty-state headline.
        static let h2 = Font.system(size: 18, weight: .regular)
        /// H3 — 16pt medium. Used for the "Start Capturing" toggle label.
        static let h3 = Font.system(size: 16, weight: .medium)
        /// H4 — 16pt regular. Primary body / list value text.
        static let h4 = Font.system(size: 16, weight: .regular)
        /// H6 — 12pt regular. Caption / secondary text.
        static let h6 = Font.system(size: 12, weight: .regular)
        /// Navigation bar title — 16pt regular.
        static let navTitle = Font.system(size: 16, weight: .regular)
    }
}
