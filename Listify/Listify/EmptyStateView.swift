import SwiftUI

/// The no-data / error screen (Figma `1050_tripstories_emptyview`).
///
/// Shows the journey-diary illustration, a headline, and a supporting message,
/// centered in the available space. When an error message is supplied it
/// replaces the default "no data" copy.
struct EmptyStateView: View {
    var headline: String = "No Trip Stories yet…"
    var message: String = "Capture Trip Stories and personalize with photos"

    var body: some View {
        VStack(spacing: Theme.Spacing.x32) {
            JourneyDiaryIllustration()
                .frame(width: 186, height: 186)

            VStack(spacing: Theme.Spacing.x8) {
                Text(headline)
                    .font(Theme.Typography.h2)
                    .foregroundStyle(Theme.Colors.labelHighEmphasis)

                Text(message)
                    .font(Theme.Typography.h4)
                    .foregroundStyle(Theme.Colors.labelMediumEmphasis)
            }
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, Theme.Spacing.x16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(headline). \(message)")
    }
}

/// A lightweight recreation of the Figma journey-diary illustration: a circular
/// map with three time-stamped location pins. Built from SF Symbols and shapes
/// so no remote assets need to be bundled.
private struct JourneyDiaryIllustration: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Theme.Colors.illustrationBackground)

            // Faint route line meandering through the map.
            RoutePath()
                .stroke(
                    Theme.Colors.illustration.opacity(0.4),
                    style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round, dash: [1, 6])
                )
                .padding(28)

            pin(icon: "house.fill", time: "10:00")
                .offset(x: -18, y: -52)

            pin(icon: "cup.and.saucer.fill", time: "13:00", timeOnRight: true)
                .offset(x: 40, y: -6)

            pin(icon: "mappin.and.ellipse", time: "16:00")
                .offset(x: -30, y: 44)
        }
    }

    private func pin(icon: String, time: String, timeOnRight: Bool = false) -> some View {
        VStack(spacing: 4) {
            ZStack {
                MapPinShape()
                    .fill(Theme.Colors.illustration)
                    .frame(width: 32, height: 40)
                Image(systemName: icon)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.white)
                    .offset(y: -4)
            }
            timeChip(time)
                .offset(x: timeOnRight ? 22 : -8)
        }
    }

    private func timeChip(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 11, weight: .semibold))
            .foregroundStyle(Theme.Colors.labelMediumEmphasis)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(
                Capsule()
                    .fill(.white)
                    .shadow(color: .black.opacity(0.12), radius: 2, x: 0, y: 1)
            )
    }
}

/// Teardrop map-pin shape.
private struct MapPinShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        let radius = width / 2
        let center = CGPoint(x: rect.midX, y: rect.minY + radius)

        path.addArc(
            center: center,
            radius: radius,
            startAngle: .degrees(150),
            endAngle: .degrees(30),
            clockwise: true
        )
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY + height))
        path.closeSubpath()
        return path
    }
}

/// A simple meandering route used as the illustration backdrop.
private struct RoutePath: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addCurve(
            to: CGPoint(x: rect.midX, y: rect.minY + rect.height * 0.3),
            control1: CGPoint(x: rect.width * 0.25, y: rect.height * 0.35),
            control2: CGPoint(x: rect.width * 0.35, y: rect.height * 0.25)
        )
        path.addCurve(
            to: CGPoint(x: rect.maxX, y: rect.midY),
            control1: CGPoint(x: rect.width * 0.7, y: rect.height * 0.35),
            control2: CGPoint(x: rect.width * 0.8, y: rect.height * 0.5)
        )
        path.addCurve(
            to: CGPoint(x: rect.midX * 0.7, y: rect.maxY),
            control1: CGPoint(x: rect.width * 0.6, y: rect.height * 0.8),
            control2: CGPoint(x: rect.width * 0.45, y: rect.height * 0.9)
        )
        return path
    }
}

#Preview("No data") {
    EmptyStateView()
}

#Preview("Error") {
    EmptyStateView(
        headline: "Something went wrong",
        message: "We couldn't load the temperature data. Pull to try again."
    )
}
