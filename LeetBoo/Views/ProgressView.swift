import SwiftUI

struct ProgressView: View {
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.pageBackground.ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        // Monthly Goals Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("This Month's Goals")
                                .font(.system(size: 13, weight: .semibold, design: .rounded))
                                .foregroundColor(.leetCodeTextSecondary)
                                .textCase(.uppercase)
                                .tracking(0.5)
                                .padding(.horizontal, 20)
                            
                            VStack(spacing: 16) {
                                // Shared variables
                                let daysInMonth = Calendar.current.range(of: .day, in: .month, for: Date())?.count ?? 30
                                
                                // 30 Day Streak
                                let streakTarget = 30
                                let currentStreak = dataManager.getCurrentStreak(for: .dailyCheckIn)
                                let daysRemaining = daysInMonth - Calendar.current.component(.day, from: Date())
                                let isStreakPossible = (currentStreak + daysRemaining) >= streakTarget
                                
                                progressRow(
                                    title: "30 Day Streak",
                                    icon: "flame.fill",
                                    color: (isStreakPossible || currentStreak >= streakTarget) ? .leetCodeOrange : .red,
                                    current: currentStreak,
                                    target: streakTarget,
                                    customStatus: (isStreakPossible || currentStreak >= streakTarget) ? nil : "Failed"
                                )
                                
                                // Monthly Badge (25 Daily Problems)
                                progressRow(
                                    title: "Monthly Badge",
                                    icon: "star.circle.fill",
                                    color: .leetCodeYellow,
                                    current: dataManager.getMonthlyCount(for: .dailyProblem),
                                    target: 25
                                )
                                
                                // Perfect Month (All Daily Problems)
                                let missedDailyProblemsCount = dataManager.getMissedDates(for: .dailyProblem).count
                                let isPerfectMonthPossible = missedDailyProblemsCount == 0

                                progressRow(
                                    title: "Perfect Month",
                                    icon: "crown.fill",
                                    color: isPerfectMonthPossible ? .leetCodeYellow : .red,
                                    current: isPerfectMonthPossible ? dataManager.getMonthlyCount(for: .dailyProblem) : 0,
                                    target: daysInMonth,
                                    customStatus: isPerfectMonthPossible ? nil : "Failed"
                                )
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
                                        HStack {
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(date.formatted(date: .long, time: .omitted))
                                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                                                    .foregroundColor(.leetCodeTextPrimary)
                                                Text("Daily Problem")
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
