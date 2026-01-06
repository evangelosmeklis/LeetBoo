import Foundation

enum ActivityType: String, Codable, CaseIterable {
    case daily = "Daily"
    case weeklyLuck = "Weekly Luck"

    var coinsPerMonth: Int {
        switch self {
        case .daily:
            return 330
        case .weeklyLuck:
            return 40
        }
    }

    var description: String {
        switch self {
        case .daily:
            return "Daily problem + check-in (11 coins/day)"
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
        if !Calendar.current.isDateInToday(lastDate) {
            completedToday = false
        }
    }
}
