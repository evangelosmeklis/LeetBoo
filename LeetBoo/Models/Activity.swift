import Foundation

enum ActivityType: String, Codable, CaseIterable {
    case dailyCheckIn = "Daily Check-In"
    case dailyProblem = "Daily Problem"
    case weeklyLuck = "Weekly Luck"

    var coinsPerMonth: Int {
        switch self {
        case .dailyCheckIn:
            return 30
        case .dailyProblem:
            return 300
        case .weeklyLuck:
            return 40
        }
    }

    var description: String {
        switch self {
        case .dailyCheckIn:
            return "Daily login reward (1 coin/day)"
        case .dailyProblem:
            return "Complete daily problem (10 coins/day)"
        case .weeklyLuck:
            return "Collect 10 coins every Monday"
        }
    }
}

struct Activity: Identifiable, Codable {
    let id: UUID
    let type: ActivityType
    var isEnabled: Bool
    var completedToday: Bool
    var lastCompletedDate: Date?

    init(type: ActivityType, isEnabled: Bool = false) {
        self.id = UUID()
        self.type = type
        self.isEnabled = isEnabled
        self.completedToday = false
        self.lastCompletedDate = nil
    }

    mutating func checkAndResetDaily() {
        guard let lastDate = lastCompletedDate else { return }

        // For daily activities, reset if not today
        if type == .dailyCheckIn || type == .dailyProblem {
            if !Calendar.current.isDateInToday(lastDate) {
                completedToday = false
            }
        }
        // For weekly luck, reset if not this week or if it's a new Monday
        else if type == .weeklyLuck {
            let calendar = Calendar.current
            let currentWeekday = calendar.component(.weekday, from: Date())
            _ = calendar.component(.weekday, from: lastDate) // lastWeekday unused

            // Reset if it's Monday and we last completed on a previous Monday (or earlier in week)
            if currentWeekday == 2 && !calendar.isDateInToday(lastDate) {
                completedToday = false
            }
            // Or if we're in a different week
            else if !calendar.isDate(Date(), equalTo: lastDate, toGranularity: .weekOfYear) {
                completedToday = false
            }
        }
    }
}
