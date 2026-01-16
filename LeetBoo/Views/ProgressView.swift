import SwiftUI

struct ProgressView: View {
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.pageBackground.ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 28) {
                        // Progress Section
                        VStack(alignment: .leading, spacing: 18) {
                            HStack(spacing: 10) {
                                ZStack {
                                    Circle()
                                        .fill(Color.leetCodeOrange.opacity(0.15))
                                        .frame(width: 28, height: 28)
                                    
                                    Image(systemName: "chart.line.uptrend.xyaxis")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.leetCodeOrange)
                                }
                                
                                Text("PROGRESS")
                                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                                    .foregroundColor(.leetCodeTextSecondary)
                                    .tracking(1.5)
                            }
                            .padding(.horizontal, 20)

                            VStack(spacing: 16) {
                                let streakTarget = 30
                                let currentStreak = dataManager.getCurrentStreak(for: .dailyCheckIn)

                                progressRow(
                                    title: "30 Day Streak",
                                    icon: "flame.fill",
                                    color: .leetCodeOrange,
                                    current: currentStreak,
                                    target: streakTarget
                                )
                            }
                            .padding(.horizontal, 20)
                        }

                        // Daily Status Section
                        VStack(alignment: .leading, spacing: 18) {
                            HStack(spacing: 10) {
                                ZStack {
                                    Circle()
                                        .fill(Color.leetCodeGreen.opacity(0.15))
                                        .frame(width: 28, height: 28)
                                    
                                    Image(systemName: "checkmark.seal.fill")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.leetCodeGreen)
                                }
                                
                                Text("TODAY'S MISSIONS")
                                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                                    .foregroundColor(.leetCodeTextSecondary)
                                    .tracking(1.5)
                            }
                            .padding(.horizontal, 20)

                            VStack(spacing: 12) {
                                let isMonday = Calendar.current.component(.weekday, from: Date()) == 2

                                completionRow(
                                    title: "Daily Check-in",
                                    icon: "checkmark.circle.fill",
                                    isCompleted: dataManager.isActivityCompletedToday(.dailyCheckIn)
                                )

                                completionRow(
                                    title: "Daily Challenge",
                                    icon: "brain.head.profile.fill",
                                    isCompleted: dataManager.isActivityCompletedToday(.dailyProblem)
                                )

                                completionRow(
                                    title: "Weekly Premium Challenges",
                                    icon: "star.circle.fill",
                                    isCompleted: dataManager.isWeeklyMissionCompleted("weeklyPremium")
                                )

                                if isMonday {
                                    completionRow(
                                        title: "Lucky Monday",
                                        icon: "clover.fill",
                                        isCompleted: dataManager.isActivityCompletedToday(.weeklyLuck)
                                    )
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        // Missed Challenges Section
                        VStack(alignment: .leading, spacing: 18) {
                            HStack(spacing: 10) {
                                ZStack {
                                    Circle()
                                        .fill(Color.leetCodeRed.opacity(0.15))
                                        .frame(width: 28, height: 28)
                                    
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.leetCodeRed)
                                }
                                
                                Text("MISSED CHALLENGES (THIS MONTH)")
                                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                                    .foregroundColor(.leetCodeTextSecondary)
                                    .tracking(1.5)
                            }
                            .padding(.horizontal, 20)

                            let missedDates = dataManager.getMissedDates(for: .dailyProblem)

                            if missedDates.isEmpty {
                                emptyStateView(message: "You haven't missed any challenges this month! Keep it up!")
                            } else {
                                LazyVStack(spacing: 12) {
                                    ForEach(missedDates, id: \.self) { date in
                                        missedRow(dateText: date.formatted(date: .long, time: .omitted), subtitle: "Daily Challenge")
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.vertical, 24)
                }
            }
            .navigationTitle("Progress")
        }
    }
    
    private func progressRow(title: String, icon: String, color: Color, current: Int, target: Int, customStatus: String? = nil) -> some View {
        let progress = min(1.0, Double(current) / Double(target))
        
        return HStack(spacing: 18) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 52, height: 52)
                
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(title)
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundColor(.leetCodeTextPrimary)
                    
                    Spacer()
                    
                    if let status = customStatus {
                        Text(status)
                            .font(.system(size: 15, weight: .bold, design: .monospaced))
                            .foregroundColor(color)
                    } else {
                        Text("\(current)/\(target)")
                            .font(.system(size: 15, weight: .bold, design: .monospaced))
                            .foregroundColor(color)
                    }
                }
                
                // Enhanced Progress Bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.subtleGray.opacity(0.5))
                            .frame(height: 10)
                        
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [color, color.opacity(0.7)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: max(0, geometry.size.width * progress), height: 10)
                            .shadow(color: color.opacity(0.4), radius: 4, x: 0, y: 2)
                    }
                }
                .frame(height: 10)
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
                                colors: [Color.white.opacity(0.9), Color.white.opacity(0.7)],
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
                        colors: [Color.white.opacity(0.6), Color.white.opacity(0.2)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )
        )
        .shadow(color: Color.black.opacity(0.08), radius: 20, x: 0, y: 8)
    }

    private func completionRow(title: String, icon: String, isCompleted: Bool) -> some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill((isCompleted ? Color.leetCodeGreen : Color.subtleGray).opacity(0.15))
                    .frame(width: 44, height: 44)

                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(isCompleted ? .leetCodeGreen : .leetCodeTextSecondary)
            }

            Text(title)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundColor(.leetCodeTextPrimary)

            Spacer()

            Text(isCompleted ? "Completed" : "Not yet")
                .font(.system(size: 13, weight: .bold, design: .monospaced))
                .foregroundColor(isCompleted ? .leetCodeGreen : .leetCodeTextSecondary)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(isCompleted ? Color.leetCodeGreen.opacity(0.1) : Color.subtleGray.opacity(0.3))
                )
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.glassBackground)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                colors: [Color.white.opacity(0.9), Color.white.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    LinearGradient(
                        colors: [Color.white.opacity(0.6), Color.white.opacity(0.2)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )
        )
        .shadow(color: Color.black.opacity(0.06), radius: 15, x: 0, y: 6)
    }

    private func missedRow(dateText: String, subtitle: String) -> some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text(dateText)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(.leetCodeTextPrimary)
                Text(subtitle)
                    .font(.system(size: 13, weight: .medium, design: .monospaced))
                    .foregroundColor(.leetCodeTextSecondary)
                    .tracking(0.3)
            }

            Spacer()

            Text("MISSED")
                .font(.system(size: 12, weight: .bold, design: .monospaced))
                .foregroundColor(.leetCodeRed)
                .padding(.horizontal, 14)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(Color.leetCodeRed.opacity(0.1))
                )
                .overlay(
                    Capsule()
                        .stroke(Color.leetCodeRed.opacity(0.3), lineWidth: 1)
                )
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.glassBackground)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                colors: [Color.white.opacity(0.9), Color.white.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    LinearGradient(
                        colors: [Color.white.opacity(0.6), Color.white.opacity(0.2)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )
        )
        .shadow(color: Color.black.opacity(0.06), radius: 15, x: 0, y: 6)
    }
    
    private func emptyStateView(message: String) -> some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(Color.leetCodeGreen.opacity(0.15))
                    .frame(width: 80, height: 80)
                
                Image(systemName: "hand.thumbsup.fill")
                    .font(.system(size: 44, weight: .semibold))
                    .foregroundColor(.leetCodeGreen)
            }
            .padding(.bottom, 8)
            
            Text(message)
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundColor(.leetCodeTextSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 48)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.glassBackground)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(
                            LinearGradient(
                                colors: [Color.white.opacity(0.8), Color.white.opacity(0.6)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.glassBorder, lineWidth: 1.5)
        )
        .shadow(color: Color.black.opacity(0.06), radius: 20, x: 0, y: 8)
        .padding(.horizontal, 20)
    }
}
