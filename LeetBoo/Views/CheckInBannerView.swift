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
                        .fill(iconColor.opacity(0.12))
                        .frame(width: 48, height: 48)

                    Image(systemName: iconName)
                        .font(.system(size: 22))
                        .foregroundColor(iconColor)
                }

                // Text content
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .foregroundColor(.leetCodeTextPrimary)

                    Text(subtitle)
                        .font(.system(size: 13, weight: .medium, design: .rounded))
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
                            .background(Color.subtleGray)
                            .cornerRadius(12)
                    }

                    Button(action: onConfirm) {
                        HStack(spacing: 4) {
                            Text("Yes")
                                .font(.system(size: 13, weight: .bold, design: .rounded))
                            Text("+\(coins)")
                                .font(.system(size: 13, weight: .bold, design: .rounded))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(iconColor)
                        .cornerRadius(12)
                        .shadow(color: iconColor.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                }
            }
            .padding(16)
            .background(Color.cardBackground)
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.08), radius: 16, x: 0, y: 8)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(iconColor.opacity(0.2), lineWidth: 1)
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
        case .daily:
            return "Did you complete today's problem?"
        case .weeklyLuck:
            return "It's Monday! Collect your weekly luck?"
        }
    }

    private var subtitle: String {
        switch activityType {
        case .daily:
            return "Daily check-in + problem"
        case .weeklyLuck:
            return "Weekly bonus coins"
        }
    }

    private var iconName: String {
        switch activityType {
        case .daily:
            return "brain.head.profile.fill"
        case .weeklyLuck:
            return "star.fill"
        }
    }

    private var iconColor: Color {
        switch activityType {
        case .daily:
            return .leetCodeOrange
        case .weeklyLuck:
            return .leetCodeYellow
        }
    }

    private var coins: Int {
        switch activityType {
        case .daily:
            return 11
        case .weeklyLuck:
            return 10
        }
    }
}
