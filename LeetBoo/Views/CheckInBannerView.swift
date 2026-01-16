import SwiftUI

struct CheckInBannerView: View {
    let activityType: ActivityType
    let onConfirm: () -> Void
    let onDismiss: () -> Void

    @State private var isVisible = false

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 14) {
                // Icon
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.15))
                        .frame(width: 44, height: 44)

                    Image(systemName: iconName)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(iconColor)
                }

                // Text content
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundColor(.leetCodeTextPrimary)

                    Text(subtitle)
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(.leetCodeTextSecondary)
                }

                Spacer()

                // Action buttons
                HStack(spacing: 8) {
                    Button(action: onDismiss) {
                        Text("Later")
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .foregroundColor(.leetCodeTextSecondary)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .background(
                                Capsule()
                                    .fill(Color.subtleGray.opacity(0.3))
                            )
                    }
                    .buttonStyle(TechButtonStyle())

                    Button(action: onConfirm) {
                        HStack(spacing: 4) {
                            Text("+")
                                .font(.system(size: 14, weight: .bold, design: .monospaced))
                            Text("\(coins)")
                                .font(.system(size: 14, weight: .bold, design: .monospaced))
                        }
                        .foregroundColor(.black)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(
                            Capsule()
                                .fill(iconColor)
                        )
                    }
                    .buttonStyle(TechButtonStyle())
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(iconColor.opacity(0.3), lineWidth: 1)
                    )
            )
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
