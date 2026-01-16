import Foundation
import Combine

class DataManager: ObservableObject {
    @Published var userData: UserData
    @Published var showDailyCheckInBanner: Bool = false
    @Published var showDailyProblemBanner: Bool = false
    @Published var showWeeklyLuckBanner: Bool = false

    private let userDataKey = "leetBooUserData"

    init() {
        if let data = UserDefaults.standard.data(forKey: userDataKey),
           let decoded = try? JSONDecoder().decode(UserData.self, from: data) {
            self.userData = decoded
        } else {
            self.userData = UserData()
        }
        checkAndResetDailyActivities()
    }

    func saveData() {
        if let encoded = try? JSONEncoder().encode(userData) {
            UserDefaults.standard.set(encoded, forKey: userDataKey)
        }
    }

    func updateCurrentCoins(_ coins: Int) {
        userData.currentCoins = coins
        saveData()
    }

    func addCoins(_ coins: Int) {
        userData.currentCoins += coins
        saveData()
    }

    func updateTargetCoins(_ coins: Int) {
        userData.targetCoins = coins
        saveData()
    }

    func isOneTimeMissionCompleted(_ key: String) -> Bool {
        userData.completedOneTimeMissions.contains(key)
    }

    func completeOneTimeMission(_ key: String) {
        userData.completedOneTimeMissions.insert(key)
        saveData()
    }

    func isActivityCompletedToday(_ type: ActivityType) -> Bool {
        userData.activities.first(where: { $0.type == type })?.completedToday ?? false
    }

    func isWeeklyMissionCompleted(_ key: String, date: Date = Date()) -> Bool {
        userData.completedWeeklyMissions.contains(weeklyMissionKey(key, date: date))
    }

    func completeWeeklyMission(_ key: String, date: Date = Date()) {
        userData.completedWeeklyMissions.insert(weeklyMissionKey(key, date: date))
        saveData()
    }

    private func weeklyMissionKey(_ key: String, date: Date) -> String {
        let calendar = Calendar.current
        let weekOfYear = calendar.component(.weekOfYear, from: date)
        let year = calendar.component(.yearForWeekOfYear, from: date)
        return "\(key)-\(year)-\(weekOfYear)"
    }

    // MARK: - Activity Logging & Progress

    func logActivity(type: ActivityType, date: Date) {
        let calendar = Calendar.current
        
        // Check if already logged for this date (to prevent duplicates for single-day activities)
        // We only restrict duplicates for daily type activities on the same day
        let alreadyLogged = userData.activityLog.contains { entry in
            return entry.activityType == type && calendar.isDate(entry.date, inSameDayAs: date)
        }
        
        if alreadyLogged {
            return
        }

        // Add coins
        // (If it's weekly luck, we might want to check week uniqueness, but keeping simple for now)
        // Note: The actual coin addition often happens in specific methods, but if we use this for time travel,
        // we should add the coins here if they haven't been added.
        // For Time Travel, we call this directly. For daily usage, we might call this alongside confirmCheckIn.
        
        // Let's rely on the caller to add coins via addCoins() if needed, OR handling it here.
        // To allow Time Travel to add coins:
        if type == .dailyCheckIn { addCoins(1) }
        else if type == .dailyProblem { addCoins(10) }
        
        let newEntry = ActivityLogEntry(id: UUID(), date: date, activityType: type, coinsEarned: 0) // tracking coins separately for now
        userData.activityLog.append(newEntry)
        userData.activityLog.sort { $0.date < $1.date }
        
        saveData()
    }
    
    func getCurrentStreak(for type: ActivityType) -> Int {
        let calendar = Calendar.current
        let today = Date()
        
        let logs = userData.activityLog
            .filter { $0.activityType == type }
            .sorted { $0.date > $1.date } // Newest first
        
        var streak = 0
        var checkDate = today
        
        // Check if done today
        if let first = logs.first, calendar.isDate(first.date, inSameDayAs: today) {
            streak += 1
            checkDate = calendar.date(byAdding: .day, value: -1, to: checkDate)!
        } else {
            // If not done today, check if done yesterday (streak intact)
            let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
            if let first = logs.first, calendar.isDate(first.date, inSameDayAs: yesterday) {
                // Streak continues from yesterday
            } else {
                // Streak broken
                return 0
            }
            checkDate = yesterday
        }
        
        // Check previous days
        for i in 0..<logs.count {
            if i == 0 && streak == 1 { continue } // Already counted today
            
            let logDate = logs[i].date
            if calendar.isDate(logDate, inSameDayAs: checkDate) {
                streak += 1
                checkDate = calendar.date(byAdding: .day, value: -1, to: checkDate)!
            } else if calendar.isDate(logDate, inSameDayAs: calendar.date(byAdding: .day, value: 1, to: checkDate)!) {
                // Duplicate entry for same day, ignore
                continue
            } else {
                // Gap found
                break
            }
        }
        
        return streak
    }
    
    func getMonthlyCount(for type: ActivityType) -> Int {
        let calendar = Calendar.current
        let now = Date()
        
        let logs = userData.activityLog.filter { entry in
            return entry.activityType == type &&
                   calendar.isDate(entry.date, equalTo: now, toGranularity: .month) &&
                   calendar.isDate(entry.date, equalTo: now, toGranularity: .year)
        }
        
        // Count unique days
        let uniqueDays = Set(logs.map { calendar.startOfDay(for: $0.date) })
        return uniqueDays.count
    }
    
    func getMissedDates(for type: ActivityType) -> [Date] {
        let calendar = Calendar.current
        let now = Date()
        
        guard let range = calendar.range(of: .day, in: .month, for: now),
              let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: now)) else {
            return []
        }
        
        let dayCount = range.count
        let todayStart = calendar.startOfDay(for: now)
        
        var missedDates: [Date] = []
        
        for day in 1...dayCount {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: monthStart) {
                if date >= todayStart {
                    continue
                }
                // Check if log exists for this date
                let exists = userData.activityLog.contains { entry in
                    return entry.activityType == type && calendar.isDate(entry.date, inSameDayAs: date)
                }
                
                if !exists {
                    missedDates.append(date)
                }
            }
        }
        
        return missedDates.sorted(by: { $0 > $1 }) // Newest missed first
    }

    func getMissedWeeklyMissions(for key: String, date: Date = Date()) -> [Date] {
        let calendar = Calendar.current
        guard let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: date)),
              let monthRange = calendar.range(of: .day, in: .month, for: date) else {
            return []
        }

        let monthEnd = calendar.date(byAdding: .day, value: monthRange.count, to: monthStart) ?? date
        let todayStart = calendar.startOfDay(for: date)
        var missedWeeks: [Date] = []
        var cursor = monthStart

        while cursor < monthEnd {
            guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: cursor) else {
                break
            }

            let weekStart = weekInterval.start
            let weekEnd = weekInterval.end

            if weekEnd <= todayStart && weekEnd > monthStart {
                let weekKey = weeklyMissionKey(key, date: weekStart)
                if !userData.completedWeeklyMissions.contains(weekKey) {
                    missedWeeks.append(weekStart)
                }
            }

            cursor = weekEnd
        }

        return missedWeeks.sorted(by: { $0 > $1 })
    }

    func updateCustomMonthlyRate(_ rate: Int?) {
        userData.customMonthlyRate = rate
        saveData()
    }

    func toggleActivity(_ activityType: ActivityType) {
        if let index = userData.activities.firstIndex(where: { $0.type == activityType }) {
            userData.activities[index].isEnabled.toggle()
            saveData()
        }
    }

    func markActivityDone(_ activityType: ActivityType) {
        if let index = userData.activities.firstIndex(where: { $0.type == activityType }) {
            userData.activities[index].completedToday = true
            userData.activities[index].lastCompletedDate = Date()
            saveData()
        }
    }

    func checkAndResetDailyActivities() {
        for i in 0..<userData.activities.count {
            userData.activities[i].checkAndResetDaily()
        }
        saveData()
    }

    func updateNotificationSettings(_ settings: NotificationSettings) {
        userData.notificationSettings = settings
        saveData()
    }

    // MARK: - Check-In Banner Management

    func triggerCheckInBanner(for activityType: ActivityType) {
        // Check if activity is enabled
        guard let activity = userData.activities.first(where: { $0.type == activityType }),
              activity.isEnabled else {
            return
        }

        // Don't show if already completed today
        if activity.completedToday {
            return
        }

        // Don't show if dismissed today
        if wasDismissedToday(activityType) {
            return
        }

        // Show appropriate banner
        switch activityType {
        case .dailyCheckIn:
            showDailyCheckInBanner = true
        case .dailyProblem:
            showDailyProblemBanner = true
        case .weeklyLuck:
            // Only show on Mondays
            if Calendar.current.component(.weekday, from: Date()) == 2 {
                showWeeklyLuckBanner = true
            }
        }
    }

    func checkAndShowBannersOnAppOpen() {
        // Clear dismissals from previous days
        clearOldDismissals()

        // Check each enabled activity
        for activity in userData.activities where activity.isEnabled {
            if !activity.completedToday && !wasDismissedToday(activity.type) {
                switch activity.type {
                case .dailyCheckIn:
                    showDailyCheckInBanner = true
                case .dailyProblem:
                    showDailyProblemBanner = true
                case .weeklyLuck:
                    // Only on Mondays
                    if Calendar.current.component(.weekday, from: Date()) == 2 {
                        showWeeklyLuckBanner = true
                    }
                }
            }
        }
    }

    private func wasDismissedToday(_ activityType: ActivityType) -> Bool {
        guard let dismissalDate = userData.dismissedBanners[activityType.rawValue] else {
            return false
        }
        return Calendar.current.isDateInToday(dismissalDate)
    }

    private func clearOldDismissals() {
        let calendar = Calendar.current
        userData.dismissedBanners = userData.dismissedBanners.filter { _, date in
            calendar.isDateInToday(date)
        }
        saveData()
    }

    func confirmCheckIn(for activityType: ActivityType) {
        // Add coins based on activity type
        let coins: Int
        switch activityType {
        case .dailyCheckIn:
            coins = 1
        case .dailyProblem:
            coins = 10
        case .weeklyLuck:
            coins = 10
        }
        addCoins(coins)

        // Mark activity as completed
        markActivityDone(activityType)
        
        // Log activity for history/streak
        logActivity(type: activityType, date: Date())

        // Clear dismissal if any
        userData.dismissedBanners.removeValue(forKey: activityType.rawValue)
        saveData()

        // Hide banner
        switch activityType {
        case .dailyCheckIn:
            showDailyCheckInBanner = false
        case .dailyProblem:
            showDailyProblemBanner = false
        case .weeklyLuck:
            showWeeklyLuckBanner = false
        }

        // Suppress remaining notifications for this activity today
        NotificationManager.shared.suppressNotificationsForToday(activityType: activityType)
    }

    func dismissBanner(for activityType: ActivityType) {
        // Record dismissal
        userData.dismissedBanners[activityType.rawValue] = Date()
        saveData()

        // Hide banner
        switch activityType {
        case .dailyCheckIn:
            showDailyCheckInBanner = false
        case .dailyProblem:
            showDailyProblemBanner = false
        case .weeklyLuck:
            showWeeklyLuckBanner = false
        }
    }
}
