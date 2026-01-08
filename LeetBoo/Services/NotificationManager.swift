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

    func scheduleDailyNotifications(for activities: [Activity], settings: NotificationSettings) {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()

        guard settings.enableNotifications else { return }

        let calendar = Calendar.current
        let enabledActivities = activities.filter { $0.isEnabled }

        for activity in enabledActivities {
            switch activity.type {
            case .daily:
                scheduleDailyReminders(settings: settings, calendar: calendar)
            case .weeklyLuck:
                scheduleWeeklyLuckReminder(settings: settings, calendar: calendar)
            }
        }
    }

    private func scheduleDailyReminders(settings: NotificationSettings, calendar: Calendar) {
        let reminderTimes = settings.dailyReminderTimes

        for (index, time) in reminderTimes.enumerated() {
            let content = UNMutableNotificationContent()
            content.title = "LeetBoo Daily Reminder"
            content.body = "Time to solve your daily Leetcode problem and check in! (11 coins)"
            content.sound = .default

            var dateComponents = calendar.dateComponents([.hour, .minute], from: time)

            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let identifier = "daily_reminder_\(index)"
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

    func suppressNotificationsForToday(activityType: ActivityType) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            let identifiersToRemove: [String]

            switch activityType {
            case .daily:
                // Remove all pending daily notifications for today
                identifiersToRemove = requests
                    .filter { $0.identifier.starts(with: "daily_reminder_") }
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
