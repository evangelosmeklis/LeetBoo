import Foundation
import Combine

class DataManager: ObservableObject {
    @Published var userData: UserData

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
}
