import SwiftUI

struct ProgressView: View {
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.pageBackground.ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        // Progress Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Progress")
                                .font(.system(size: 13, weight: .semibold, design: .rounded))
                                .foregroundColor(.leetCodeTextSecondary)
                                .textCase(.uppercase)
                                .tracking(0.5)
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
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Today's Missions")
                                .font(.system(size: 13, weight: .semibold, design: .rounded))
                                .foregroundColor(.leetCodeTextSecondary)
                                .textCase(.uppercase)
                                .tracking(0.5)
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
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Missed Challenges (This Month)")
                                .font(.system(size: 13, weight: .semibold, design: .rounded))
                                .foregroundColor(.leetCodeTextSecondary)
                                .textCase(.uppercase)
                                .tracking(0.5)
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
        
        return HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.12))
                    .frame(width: 48, height: 48)
                
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(.leetCodeTextPrimary)
                    
                    Spacer()
                    
                    if let status = customStatus {
                        Text(status)
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundColor(color)
                    } else {
                        Text("\(current)/\(target)")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundColor(color)
                    }
                }
                
                // Progress Bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.subtleGray)
                            .frame(height: 8)
                        
                        Capsule()
                            .fill(color)
                            .frame(width: max(0, geometry.size.width * progress), height: 8)
                    }
                }
                .frame(height: 8)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.cardBackground)
                .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.5), lineWidth: 1)
        )
    }

    private func completionRow(title: String, icon: String, isCompleted: Bool) -> some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill((isCompleted ? Color.leetCodeGreen : Color.subtleGray).opacity(0.12))
                    .frame(width: 40, height: 40)

                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(isCompleted ? .leetCodeGreen : .leetCodeTextSecondary)
            }

            Text(title)
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundColor(.leetCodeTextPrimary)

            Spacer()

            Text(isCompleted ? "Completed" : "Not yet")
                .font(.system(size: 13, weight: .bold, design: .rounded))
                .foregroundColor(isCompleted ? .leetCodeGreen : .leetCodeTextSecondary)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.cardBackground)
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.white.opacity(0.5), lineWidth: 1)
        )
    }

    private func missedRow(dateText: String, subtitle: String) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(dateText)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(.leetCodeTextPrimary)
                Text(subtitle)
                    .font(.system(size: 13, weight: .regular, design: .rounded))
                    .foregroundColor(.leetCodeTextSecondary)
            }

            Spacer()

            Text("Missed")
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor(.red.opacity(0.8))
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(Color.red.opacity(0.1))
                .cornerRadius(8)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.cardBackground)
                .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.5), lineWidth: 1)
        )
    }
    
    private func emptyStateView(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "hand.thumbsup.fill")
                .font(.system(size: 40))
                .foregroundColor(.leetCodeGreen)
                .padding(.bottom, 8)
            
            Text(message)
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundColor(.leetCodeTextSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.cardBackground.opacity(0.5))
        )
        .padding(.horizontal, 20)
    }
}
