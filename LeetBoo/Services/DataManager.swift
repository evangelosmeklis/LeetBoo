import Foundation
import Combine

class DataManager: ObservableObject {
    @Published var userData: UserData
    @Published var showDailyBanner: Bool = false
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
        // Don't show if already confirmed today
        if userData.hasConfirmedCheckInToday && Calendar.current.isDateInToday(userData.lastCheckInPromptDate ?? .distantPast) {
            return
        }

        // Check if activity is enabled
        guard let activity = userData.activities.first(where: { $0.type == activityType }),
              activity.isEnabled else {
            return
        }

        // Don't show if already completed today
        if activity.completedToday {
            return
        }

        // Show appropriate banner
        switch activityType {
        case .daily:
            showDailyBanner = true
        case .weeklyLuck:
            // Only show on Mondays
            if Calendar.current.component(.weekday, from: Date()) == 2 {
                showWeeklyLuckBanner = true
            }
        }
    }

    func checkAndShowBannersOnAppOpen() {
        resetDailyCheckInConfirmation()

        // Check each enabled activity
        for activity in userData.activities where activity.isEnabled {
            if !activity.completedToday {
                switch activity.type {
                case .daily:
                    showDailyBanner = true
                case .weeklyLuck:
                    // Only on Mondays
                    if Calendar.current.component(.weekday, from: Date()) == 2 {
                        showWeeklyLuckBanner = true
                    }
                }
            }
        }
    }

    func resetDailyCheckInConfirmation() {
        if !Calendar.current.isDateInToday(userData.lastCheckInPromptDate ?? .distantPast) {
            userData.hasConfirmedCheckInToday = false
            saveData()
        }
    }

    func confirmCheckIn(for activityType: ActivityType) {
        // Add coins based on activity type
        let coins = activityType == .daily ? 11 : 10
        addCoins(coins)

        // Mark activity as completed
        markActivityDone(activityType)

        // Update confirmation state
        userData.hasConfirmedCheckInToday = true
        userData.lastCheckInPromptDate = Date()
        saveData()

        // Hide banner
        switch activityType {
        case .daily:
            showDailyBanner = false
        case .weeklyLuck:
            showWeeklyLuckBanner = false
        }

        // Suppress remaining notifications for this activity today
        NotificationManager.shared.suppressNotificationsForToday(activityType: activityType)
    }

    func dismissBanner(for activityType: ActivityType) {
        switch activityType {
        case .daily:
            showDailyBanner = false
        case .weeklyLuck:
            showWeeklyLuckBanner = false
        }
    }
}
