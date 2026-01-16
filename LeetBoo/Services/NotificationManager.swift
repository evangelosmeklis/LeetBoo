import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()

    private init() {}

    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            completion(granted)
        }
    }

    func scheduleNotifications(userData: UserData) {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()

        let settings = userData.notificationSettings
        guard settings.enableNotifications else { return }

        let calendar = Calendar.current
        let enabledActivities = userData.activities.filter { $0.isEnabled }

        for activity in enabledActivities {
            switch activity.type {
            case .dailyCheckIn:
                scheduleDailyCheckInReminders(settings: settings, calendar: calendar)
            case .dailyProblem:
                scheduleDailyProblemReminders(settings: settings, calendar: calendar)
            case .weeklyLuck:
                scheduleWeeklyLuckReminder(settings: settings, calendar: calendar)
            }
        }
        
        if settings.magicNotificationsEnabled {
            scheduleMagicNotifications(calendar: calendar, userData: userData)
        }
    }

    private func scheduleDailyCheckInReminders(settings: NotificationSettings, calendar: Calendar) {
        let reminderTimes = settings.dailyReminderTimes

        for (index, time) in reminderTimes.enumerated() {
            let content = UNMutableNotificationContent()
            content.title = "Welcome Back!"
            content.body = "Check in to LeetBoo and earn your daily coin! (+1)"
            content.sound = .default

            let dateComponents = calendar.dateComponents([.hour, .minute], from: time)

            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let identifier = "daily_checkin_reminder_\(index)"
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request)
        }
    }

    private func scheduleDailyProblemReminders(settings: NotificationSettings, calendar: Calendar) {
        let reminderTimes = settings.dailyReminderTimes

        for (index, time) in reminderTimes.enumerated() {
            let content = UNMutableNotificationContent()
            content.title = "LeetBoo Daily Problem"
            content.body = "Time to solve your daily Leetcode problem! (+10)"
            content.sound = .default

            let dateComponents = calendar.dateComponents([.hour, .minute], from: time)

            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let identifier = "daily_problem_reminder_\(index)"
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request)
        }
    }

    private func scheduleWeeklyLuckReminder(settings: NotificationSettings, calendar: Calendar) {
        let content = UNMutableNotificationContent()
        content.title = "Weekly Luck Available!"
        content.body = "It's Monday! Don't forget to claim your 10 weekly luck coins!"
        content.sound = .default

        // Use the first reminder time for Weekly Luck
        let firstTime = settings.dailyReminderTimes.first ?? Date()
        var dateComponents = calendar.dateComponents([.hour, .minute], from: firstTime)
        dateComponents.weekday = 2 // Monday

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "weekly_luck_reminder", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }
    
    private func scheduleMagicNotifications(calendar: Calendar, userData: UserData) {
        scheduleContestReminders(calendar: calendar)
        scheduleMagicUpdates(calendar: calendar, userData: userData)
    }
    
    private func scheduleContestReminders(calendar: Calendar) {
        let content = UNMutableNotificationContent()
        content.title = "Weekend Contests"
        content.body = "Weekly contest Saturday, biweekly Sunday — jump in for +5 Leetcoins."
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.weekday = 7 // Saturday
        dateComponents.hour = 14
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "magic_contest_reminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    private func scheduleMagicUpdates(calendar: Calendar, userData: UserData) {
        let monthlyCoins = monthlyCoinsEarned(userData: userData)
        let target = max(1, userData.targetCoins)
        let progressPercent = Int((Double(userData.currentCoins) / Double(target) * 100).rounded())

        let messages = [
            "You have secured \(monthlyCoins) Leetcoins this month so far.",
            "You're \(userData.currentCoins)/\(target) coins — \(progressPercent)% toward your goal.",
            "Tip: First contest submission earns +200 Leetcoins.",
            "Tip: Connect GitHub or LinkedIn for +10 Leetcoins."
        ]
        
        let slots: [(weekday: Int, hour: Int, id: String)] = [
            (2, 12, "magic_update_1"),
            (4, 16, "magic_update_2"),
            (6, 18, "magic_update_3")
        ]
        
        for (index, slot) in slots.enumerated() {
            let content = UNMutableNotificationContent()
            content.title = "LeetBoo Magic"
            content.body = messages[index % messages.count]
            content.sound = .default
            
            var dateComponents = DateComponents()
            dateComponents.weekday = slot.weekday
            dateComponents.hour = slot.hour
            dateComponents.minute = 0
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: slot.id, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request)
        }
    }

    private func monthlyCoinsEarned(userData: UserData, date: Date = Date()) -> Int {
        let calendar = Calendar.current
        return userData.activityLog.reduce(0) { total, entry in
            guard calendar.isDate(entry.date, equalTo: date, toGranularity: .month),
                  calendar.isDate(entry.date, equalTo: date, toGranularity: .year) else {
                return total
            }

            switch entry.activityType {
            case .dailyCheckIn:
                return total + 1
            case .dailyProblem:
                return total + 10
            case .weeklyLuck:
                return total + 10
            }
        }
    }

    func suppressNotificationsForToday(activityType: ActivityType) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            let identifiersToRemove: [String]

            switch activityType {
            case .dailyCheckIn:
                // Remove all pending daily check-in notifications
                identifiersToRemove = requests
                    .filter { $0.identifier.starts(with: "daily_checkin_reminder_") }
                    .map { $0.identifier }
            case .dailyProblem:
                // Remove all pending daily problem notifications
                identifiersToRemove = requests
                    .filter { $0.identifier.starts(with: "daily_problem_reminder_") }
                    .map { $0.identifier }
            case .weeklyLuck:
                // Remove weekly luck notification
                identifiersToRemove = ["weekly_luck_reminder"]
            }

            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiersToRemove)
            // They will be rescheduled on the next day when settings are refreshed
        }
    }
}
