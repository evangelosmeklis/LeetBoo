import Foundation

struct UserData: Codable {
    var currentCoins: Int
    var targetCoins: Int
    var activities: [Activity]
    var notificationSettings: NotificationSettings

    init() {
        self.currentCoins = 0
        self.targetCoins = 1000
        self.activities = ActivityType.allCases.map { Activity(type: $0, isEnabled: false) }
        self.notificationSettings = NotificationSettings()
    }

    var enabledActivities: [Activity] {
        activities.filter { $0.isEnabled }
    }

    var estimatedMonthlyCoins: Int {
        enabledActivities.reduce(0) { $0 + $1.type.coinsPerMonth }
    }

    var monthsToTarget: Double {
        let remaining = max(0, targetCoins - currentCoins)
        guard estimatedMonthlyCoins > 0 else { return 0 }
        return Double(remaining) / Double(estimatedMonthlyCoins)
    }

    var daysToTarget: Int {
        Int(ceil(monthsToTarget * 30))
    }
}

struct NotificationSettings: Codable {
    var enableNotifications: Bool
    var dailyReminderTime: Date
    var reminderFrequency: ReminderFrequency

    init(enableNotifications: Bool, dailyReminderTime: Date, reminderFrequency: ReminderFrequency) {
        self.enableNotifications = enableNotifications
        self.dailyReminderTime = dailyReminderTime
        self.reminderFrequency = reminderFrequency
    }

    init() {
        self.enableNotifications = true
        var components = DateComponents()
        components.hour = 9
        components.minute = 0
        self.dailyReminderTime = Calendar.current.date(from: components) ?? Date()
        self.reminderFrequency = .twiceDaily
    }
}

enum ReminderFrequency: String, Codable, CaseIterable {
    case once = "Once Daily"
    case twiceDaily = "Twice Daily"
    case threeTimesDaily = "Three Times Daily"

    var count: Int {
        switch self {
        case .once: return 1
        case .twiceDaily: return 2
        case .threeTimesDaily: return 3
        }
    }
}
