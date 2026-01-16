import SwiftUI

struct ProgressView: View {
    @EnvironmentObject var dataManager: DataManager
    
    var overallProgress: Double {
        min(1.0, Double(dataManager.userData.currentCoins) / Double(max(1, dataManager.userData.targetCoins)))
    }
    
    var weeklyProgress: Double {
        let calendar = Calendar.current
        let today = Date()
        let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)) ?? today
        
        var completedCount = 0
        var totalCount = 0
        
        // Count daily check-ins this week
        if let dailyCheckIn = dataManager.userData.activities.first(where: { $0.type == .dailyCheckIn }), dailyCheckIn.isEnabled {
            totalCount += 7
            let weekLogs = dataManager.userData.activityLog.filter { entry in
                entry.activityType == .dailyCheckIn &&
                entry.date >= weekStart &&
                entry.date <= today
            }
            completedCount += Set(weekLogs.map { calendar.startOfDay(for: $0.date) }).count
        }
        
        // Count daily problems this week
        if let dailyProblem = dataManager.userData.activities.first(where: { $0.type == .dailyProblem }), dailyProblem.isEnabled {
            totalCount += 7
            let weekLogs = dataManager.userData.activityLog.filter { entry in
                entry.activityType == .dailyProblem &&
                entry.date >= weekStart &&
                entry.date <= today
            }
            completedCount += Set(weekLogs.map { calendar.startOfDay(for: $0.date) }).count
        }
        
        // Count weekly luck (if Monday)
        if Calendar.current.component(.weekday, from: today) == 2 {
            if let weeklyLuck = dataManager.userData.activities.first(where: { $0.type == .weeklyLuck }), weeklyLuck.isEnabled {
                totalCount += 1
                if weeklyLuck.completedToday {
                    completedCount += 1
                }
            }
        }
        
        guard totalCount > 0 else { return 0 }
        return Double(completedCount) / Double(totalCount)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Dark background
                Color.pageBackground.ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        // Header Section
                        VStack(spacing: 8) {
                            Text("Turn coding habits")
                                .font(.system(size: 28, weight: .semibold, design: .rounded))
                                .foregroundColor(.leetCodeTextPrimary)
                            
                            Text("into attainable goals")
                                .font(.system(size: 28, weight: .semibold, design: .rounded))
                                .foregroundColor(.leetCodeTextPrimary)
                        }
                        .padding(.top, 20)
                        
                        // Main Progress Card
                        VStack(spacing: 0) {
                            // Card Header
                            HStack {
                                Spacer()
                                
                                Text("MY WEEK IN REVIEW")
                                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                                    .foregroundColor(.leetCodeTextPrimary)
                                    .tracking(1.5)
                                
                                Spacer()
                            }
                            .padding(.top, 20)
                            .padding(.bottom, 24)
                            
                            // Illustration/Icon area
                            ZStack {
                                // Target/dartboard visualization
                                Circle()
                                    .fill(Color.subtleGray.opacity(0.2))
                                    .frame(width: 120, height: 120)
                                
                                Circle()
                                    .fill(Color.subtleGray.opacity(0.3))
                                    .frame(width: 80, height: 80)
                                
                                Circle()
                                    .fill(Color.subtleGray.opacity(0.4))
                                    .frame(width: 40, height: 40)
                                
                                // Dart arrows
                                Image(systemName: "arrow.up.right")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.leetCodeGreen)
                                    .offset(x: 30, y: -20)
                                
                                Image(systemName: "arrow.up.right")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.leetCodeGreen.opacity(0.7))
                                    .offset(x: 40, y: 0)
                            }
                            .padding(.bottom, 24)
                            
                            // Motivational Text
                            VStack(spacing: 8) {
                                Text("Keep a good thing going")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .foregroundColor(.leetCodeTextPrimary)
                                
                                Text("Science says that effort compounds over time.")
                                    .font(.system(size: 14, weight: .medium, design: .rounded))
                                    .foregroundColor(.leetCodeTextSecondary)
                                
                                Text("You're living proof. Don't stop now!")
                                    .font(.system(size: 14, weight: .medium, design: .rounded))
                                    .foregroundColor(.leetCodeTextSecondary)
                            }
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                            .padding(.bottom, 24)
                            
                            // Weekly Progress Bar
                            VStack(spacing: 10) {
                                HStack {
                                    Text("\(Int(weeklyProgress * 100))%")
                                        .font(.system(size: 13, weight: .bold, design: .monospaced))
                                        .foregroundColor(.leetCodeTextSecondary)
                                    
                                    Text("COMPLETE")
                                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                                        .foregroundColor(.leetCodeTextSecondary)
                                        .tracking(1)
                                    
                                    Spacer()
                                }
                                
                                GeometryReader { geometry in
                                    ZStack(alignment: .leading) {
                                        Capsule()
                                            .fill(Color.subtleGray.opacity(0.3))
                                            .frame(height: 8)
                                        
                                        Capsule()
                                            .fill(
                                                LinearGradient(
                                                    colors: [Color.leetCodeGreen, Color.leetCodeGreenBright],
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            )
                                            .frame(width: max(0, geometry.size.width * weeklyProgress), height: 8)
                                    }
                                }
                                .frame(height: 8)
                            }
                            .padding(.horizontal, 24)
                            .padding(.bottom, 24)
                            
                            Divider()
                                .background(Color.subtleGray.opacity(0.5))
                            
                            // Habits List
                            VStack(spacing: 0) {
                                // Daily Check-in
                                habitRow(
                                    title: "Daily Check-in",
                                    current: getWeeklyCount(for: .dailyCheckIn),
                                    target: 7,
                                    color: .leetCodeGreen,
                                    isEnabled: dataManager.userData.activities.first(where: { $0.type == .dailyCheckIn })?.isEnabled ?? false
                                )
                                
                                Divider()
                                    .background(Color.subtleGray.opacity(0.5))
                                    .padding(.horizontal, 20)
                                
                                // Daily Problem
                                habitRow(
                                    title: "Daily Challenge",
                                    current: getWeeklyCount(for: .dailyProblem),
                                    target: 7,
                                    color: .leetCodeGreen,
                                    isEnabled: dataManager.userData.activities.first(where: { $0.type == .dailyProblem })?.isEnabled ?? false
                                )
                                
                                Divider()
                                    .background(Color.subtleGray.opacity(0.5))
                                    .padding(.horizontal, 20)
                                
                                // Weekly Premium Challenges
                                habitRow(
                                    title: "Weekly Premium",
                                    current: dataManager.isWeeklyMissionCompleted("weeklyPremium") ? 1 : 0,
                                    target: 1,
                                    color: .leetCodeGreen,
                                    isEnabled: true
                                )
                                
                                // Weekly Luck (only show if Monday)
                                if Calendar.current.component(.weekday, from: Date()) == 2 {
                                    Divider()
                                        .background(Color.subtleGray.opacity(0.5))
                                        .padding(.horizontal, 20)
                                    
                                    habitRow(
                                        title: "Lucky Monday",
                                        current: dataManager.isActivityCompletedToday(.weeklyLuck) ? 1 : 0,
                                        target: 1,
                                        color: .leetCodeGreen,
                                        isEnabled: dataManager.userData.activities.first(where: { $0.type == .weeklyLuck })?.isEnabled ?? false
                                    )
                                }
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 24)
                                .fill(Color.cardBackground)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 24)
                                        .stroke(Color.subtleGray.opacity(0.5), lineWidth: 1)
                                )
                        )
                        .padding(.horizontal, 20)
                        
                        // Streak Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("CURRENT STREAKS")
                                .font(.system(size: 11, weight: .bold, design: .monospaced))
                                .foregroundColor(.leetCodeTextSecondary)
                                .tracking(1.5)
                                .padding(.horizontal, 20)
                            
                            VStack(spacing: 0) {
                                streakRow(
                                    title: "Daily Check-in Streak",
                                    streak: dataManager.getCurrentStreak(for: .dailyCheckIn),
                                    color: .leetCodeOrange
                                )
                                
                                Divider()
                                    .background(Color.subtleGray.opacity(0.5))
                                    .padding(.horizontal, 20)
                                
                                streakRow(
                                    title: "Daily Challenge Streak",
                                    streak: dataManager.getCurrentStreak(for: .dailyProblem),
                                    color: .leetCodeOrange
                                )
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.cardBackground)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.subtleGray.opacity(0.5), lineWidth: 1)
                                    )
                            )
                            .padding(.horizontal, 20)
                        }
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.vertical, 24)
                }
            }
            .navigationTitle("Progress")
            .navigationBarTitleDisplayMode(.inline)
        }
        .preferredColorScheme(.dark)
    }
    
    private func getWeeklyCount(for type: ActivityType) -> Int {
        let calendar = Calendar.current
        let today = Date()
        guard let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)) else {
            return 0
        }
        
        let weekLogs = dataManager.userData.activityLog.filter { entry in
            entry.activityType == type &&
            entry.date >= weekStart &&
            entry.date <= today
        }
        
        return Set(weekLogs.map { calendar.startOfDay(for: $0.date) }).count
    }
    
    private func habitRow(title: String, current: Int, target: Int, color: Color, isEnabled: Bool) -> some View {
        let isComplete = current >= target
        
        return HStack(spacing: 14) {
            // Title
            Text(title)
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundColor(isEnabled ? .leetCodeTextPrimary : .leetCodeTextSecondary.opacity(0.6))
            
            Spacer()
            
            // Circular progress indicator
            ZStack {
                Circle()
                    .stroke(Color.subtleGray.opacity(0.3), lineWidth: 3)
                    .frame(width: 44, height: 44)
                
                Circle()
                    .trim(from: 0, to: min(1.0, Double(current) / Double(max(1, target))))
                    .stroke(
                        isComplete ? color : color.opacity(0.6),
                        style: StrokeStyle(lineWidth: 3, lineCap: .round)
                    )
                    .frame(width: 44, height: 44)
                    .rotationEffect(.degrees(-90))
                
                Text("\(current)/\(target)")
                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                    .foregroundColor(isComplete ? color : .leetCodeTextSecondary)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
    }
    
    private func streakRow(title: String, streak: Int, color: Color) -> some View {
        return HStack(spacing: 14) {
            // Icon
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 40, height: 40)
                
                Image(systemName: "flame.fill")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(color)
            }
            
            // Title
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundColor(.leetCodeTextPrimary)
                
                Text("\(streak) days")
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(.leetCodeTextSecondary)
            }
            
            Spacer()
            
            // Streak Badge
            HStack(spacing: 4) {
                Image(systemName: "flame.fill")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(color)
                
                Text("\(streak)")
                    .font(.system(size: 18, weight: .bold, design: .monospaced))
                    .foregroundColor(color)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(color.opacity(0.1))
            )
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
    }
}
