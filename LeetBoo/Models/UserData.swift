import Foundation

struct UserData: Codable {
    var currentCoins: Int
    var targetCoins: Int
    var activities: [Activity]
    var notificationSettings: NotificationSettings
    var lastCheckInPromptDate: Date?
    var hasConfirmedCheckInToday: Bool

    init() {
        self.currentCoins = 0
        self.targetCoins = 1000
        self.activities = ActivityType.allCases.map { Activity(type: $0, isEnabled: false) }
        self.notificationSettings = NotificationSettings()
        self.lastCheckInPromptDate = nil
        self.hasConfirmedCheckInToday = false
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
    var dailyReminderTimes: [Date]
    var reminderFrequency: ReminderFrequency

    init(enableNotifications: Bool, dailyReminderTimes: [Date], reminderFrequency: ReminderFrequency) {
        self.enableNotifications = enableNotifications
        self.dailyReminderTimes = dailyReminderTimes
        self.reminderFrequency = reminderFrequency
    }

    init() {
        self.enableNotifications = true
        self.reminderFrequency = .twiceDaily

        // Default times: 9 AM and 6 PM
        var morning = DateComponents()
        morning.hour = 9
        morning.minute = 0

        var evening = DateComponents()
        evening.hour = 18
        evening.minute = 0

        self.dailyReminderTimes = [
            Calendar.current.date(from: morning) ?? Date(),
            Calendar.current.date(from: evening) ?? Date()
        ]
    }

    // Custom coding to handle migration from old single-time format
    enum CodingKeys: String, CodingKey {
        case enableNotifications
        case dailyReminderTime
        case dailyReminderTimes
        case reminderFrequency
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        enableNotifications = try container.decode(Bool.self, forKey: .enableNotifications)
        reminderFrequency = try container.decode(ReminderFrequency.self, forKey: .reminderFrequency)

        // Try to decode new format first
        if let times = try? container.decode([Date].self, forKey: .dailyReminderTimes) {
            dailyReminderTimes = times
        }
        // Fall back to old single-time format
        else if let singleTime = try? container.decode(Date.self, forKey: .dailyReminderTime) {
            // Migrate from single time to multiple times based on frequency
            dailyReminderTimes = Self.generateTimesFromSingle(singleTime, frequency: reminderFrequency)
        }
        // Default if neither exists
        else {
            let settings = NotificationSettings()
            dailyReminderTimes = settings.dailyReminderTimes
        }

        // Ensure we have the right number of times for the frequency
        adjustTimesForFrequency()
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(enableNotifications, forKey: .enableNotifications)
        try container.encode(dailyReminderTimes, forKey: .dailyReminderTimes)
        try container.encode(reminderFrequency, forKey: .reminderFrequency)
    }

    private static func generateTimesFromSingle(_ baseTime: Date, frequency: ReminderFrequency) -> [Date] {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: baseTime)
        let baseHour = components.hour ?? 9

        switch frequency {
        case .once:
            return [baseTime]
        case .twiceDaily:
            let time1 = calendar.date(from: DateComponents(hour: baseHour, minute: 0)) ?? baseTime
            let time2 = calendar.date(from: DateComponents(hour: min(baseHour + 6, 21), minute: 0)) ?? baseTime
            return [time1, time2]
        case .threeTimesDaily:
            let time1 = calendar.date(from: DateComponents(hour: baseHour, minute: 0)) ?? baseTime
            let time2 = calendar.date(from: DateComponents(hour: min(baseHour + 4, 17), minute: 0)) ?? baseTime
            let time3 = calendar.date(from: DateComponents(hour: min(baseHour + 8, 21), minute: 0)) ?? baseTime
            return [time1, time2, time3]
        }
    }

    mutating func adjustTimesForFrequency() {
        let count = reminderFrequency.count

        if dailyReminderTimes.count < count {
            // Add more times if needed
            while dailyReminderTimes.count < count {
                let lastTime = dailyReminderTimes.last ?? Date()
                let calendar = Calendar.current
                let newTime = calendar.date(byAdding: .hour, value: 4, to: lastTime) ?? lastTime
                dailyReminderTimes.append(newTime)
            }
        } else if dailyReminderTimes.count > count {
            // Remove extra times
            dailyReminderTimes = Array(dailyReminderTimes.prefix(count))
        }
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
