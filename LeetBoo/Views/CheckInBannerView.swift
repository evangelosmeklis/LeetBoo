import SwiftUI

struct CheckInBannerView: View {
    let activityType: ActivityType
    let onConfirm: () -> Void
    let onDismiss: () -> Void

    @State private var isVisible = false

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 16) {
                // Icon
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.15))
                        .frame(width: 52, height: 52)

                    Image(systemName: iconName)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(iconColor)
                }

                // Text content
                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.leetCodeTextPrimary)

                    Text(subtitle)
                        .font(.system(size: 13, weight: .medium, design: .monospaced))
                        .foregroundColor(.leetCodeTextSecondary)
                        .tracking(0.3)
                }

                Spacer()

                // Action buttons with modern styling
                HStack(spacing: 10) {
                    Button(action: onDismiss) {
                        Text("Later")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundColor(.leetCodeTextSecondary)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 11)
                            .background(
                                Capsule()
                                    .fill(Color.glassBackground)
                            )
                            .overlay(
                                Capsule()
                                    .stroke(Color.glassBorder, lineWidth: 1)
                            )
                    }
                    .buttonStyle(TechButtonStyle())

                    Button(action: onConfirm) {
                        HStack(spacing: 6) {
                            Text("+")
                                .font(.system(size: 16, weight: .bold, design: .monospaced))
                            Text("\(coins)")
                                .font(.system(size: 16, weight: .bold, design: .monospaced))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 11)
                        .background(
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        colors: [iconColor, iconColor.opacity(0.8)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        )
                        .shadow(color: iconColor.opacity(0.4), radius: 10, x: 0, y: 5)
                    }
                    .buttonStyle(TechButtonStyle())
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.glassBackground)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(
                                LinearGradient(
                                    colors: [Color.white.opacity(0.95), Color.white.opacity(0.85)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(
                        LinearGradient(
                            colors: [iconColor.opacity(0.4), iconColor.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
            )
            .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 10)
            .shadow(color: iconColor.opacity(0.2), radius: 15, x: 0, y: 5)
            .padding(.horizontal, 16)
            .padding(.top, 12)
        }
        .offset(y: isVisible ? 0 : -100)
        .opacity(isVisible ? 1 : 0)
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                isVisible = true
            }
        }
    }

    private var title: String {
        switch activityType {
        case .dailyCheckIn:
            return "Welcome back!"
        case .dailyProblem:
            return "Did you complete today's problem?"
        case .weeklyLuck:
            return "It's Monday! Collect your weekly luck?"
        }
    }

    private var subtitle: String {
        switch activityType {
        case .dailyCheckIn:
            return "Daily login reward"
        case .dailyProblem:
            return "Daily problem solved"
        case .weeklyLuck:
            return "Weekly bonus coins"
        }
    }

    private var iconName: String {
        switch activityType {
        case .dailyCheckIn:
            return "checkmark.circle.fill"
        case .dailyProblem:
            return "brain.head.profile.fill"
        case .weeklyLuck:
            return "star.fill"
        }
    }

    private var iconColor: Color {
        switch activityType {
        case .dailyCheckIn:
            return .leetCodeGreen
        case .dailyProblem:
            return .leetCodeOrange
        case .weeklyLuck:
            return .leetCodeYellow
        }
    }

    private var coins: Int {
        switch activityType {
        case .dailyCheckIn:
            return 1
        case .dailyProblem:
            return 10
        case .weeklyLuck:
            return 10
        }
    }
}
