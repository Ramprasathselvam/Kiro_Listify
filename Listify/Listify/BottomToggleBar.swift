import SwiftUI

/// The bottom navigation toggle (Figma `BottomNav_toggle`, height 89pt).
///
/// Shows the "Start Capturing" label with a help icon, a descriptive subtitle,
/// and a trailing switch bound to the capturing state.
struct BottomToggleBar: View {
    @Binding var isOn: Bool
    var onHelp: () -> Void = {}

    var body: some View {
        VStack(spacing: 0) {
            Divider()
                .overlay(Theme.Colors.divider)

            HStack(spacing: Theme.Spacing.x24) {
                VStack(alignment: .leading, spacing: Theme.Spacing.x4) {
                    HStack(spacing: Theme.Spacing.x4) {
                        Text("Start Capturing")
                            .font(Theme.Typography.h3)
                            .foregroundStyle(Theme.Colors.labelHighEmphasis)

                        Button(action: onHelp) {
                            Image(systemName: "questionmark.circle")
                                .font(.system(size: 18, weight: .regular))
                                .foregroundStyle(Theme.Colors.labelMediumEmphasis)
                                .frame(width: 24, height: 24)
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel("Help about capturing Trip Stories")
                    }

                    Text("Turn ON to start capturing your Trip Stories")
                        .font(Theme.Typography.h6)
                        .foregroundStyle(Theme.Colors.labelMediumEmphasis)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Toggle("", isOn: $isOn)
                    .labelsHidden()
                    .tint(Theme.Colors.primary)
            }
            .padding(.horizontal, Theme.Spacing.x24)
            .padding(.vertical, Theme.Spacing.x16)
        }
        .frame(maxWidth: .infinity)
        .background(Theme.Colors.surface)
        .compositingGroup()
        .shadow(color: .black.opacity(0.14), radius: 2.5, x: 0, y: 4)
        .shadow(color: .black.opacity(0.12), radius: 5, x: 0, y: 1)
    }
}

#Preview {
    struct Wrapper: View {
        @State private var on = false
        var body: some View {
            VStack {
                Spacer()
                BottomToggleBar(isOn: $on)
            }
        }
    }
    return Wrapper()
}
