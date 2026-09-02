import SwiftUI

/// The top navigation bar (Figma `Bars/Merge/Standard`, height 56pt).
///
/// Shows an optional back button, the screen title, and a trailing "Select"
/// action that is enabled (primary color) in the data state and disabled
/// (gray) in the empty state.
struct TopBar: View {
    let title: String
    var showsBackButton: Bool = true
    var isSelectEnabled: Bool = true
    var onBack: () -> Void = {}
    var onSelect: () -> Void = {}

    var body: some View {
        HStack(spacing: Theme.Spacing.x24) {
            HStack(spacing: Theme.Spacing.x24) {
                if showsBackButton {
                    Button(action: onBack) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 18, weight: .regular))
                            .foregroundStyle(Theme.Colors.labelHighEmphasis)
                            .frame(width: 24, height: 24)
                    }
                    .buttonStyle(.plain)
                }

                Text(title)
                    .font(Theme.Typography.navTitle)
                    .foregroundStyle(Theme.Colors.labelHighEmphasis)

                Spacer(minLength: 0)
            }

            Button(action: onSelect) {
                Text("Select")
                    .font(Theme.Typography.h4)
                    .foregroundStyle(isSelectEnabled ? Theme.Colors.primary : Theme.Colors.labelDisabled)
            }
            .buttonStyle(.plain)
            .disabled(!isSelectEnabled)
        }
        .padding(Theme.Spacing.x16)
        .frame(height: 56)
        .frame(maxWidth: .infinity)
        .background(Theme.Colors.surfaceElevated)
        .compositingGroup()
        .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 2)
        .shadow(color: .black.opacity(0.12), radius: 5, x: 0, y: 1)
        .accessibilityElement(children: .contain)
    }
}

#Preview("Data state") {
    VStack(spacing: 40) {
        TopBar(title: "Trip Stories")
        TopBar(title: "Trip Stories", showsBackButton: false, isSelectEnabled: false)
    }
    .padding(.top, 40)
    .background(Color(white: 0.95))
}
