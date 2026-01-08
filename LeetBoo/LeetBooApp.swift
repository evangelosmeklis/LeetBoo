//
//  LeetBooApp.swift
//  LeetBoo
//
//  Created by Evangelos Meklis on 6/1/26.
//

import SwiftUI
import UserNotifications

@main
struct LeetBooApp: App {
    @StateObject private var dataManager = DataManager()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init() {
        NotificationManager.shared.requestAuthorization { _ in }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataManager)
                .onAppear {
                    appDelegate.dataManager = dataManager
                }
        }
    }
}

// AppDelegate to handle notification taps
class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    weak var dataManager: DataManager?

    func application(_ application: UIApplication,
                    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }

    // Handle notification when app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
                              withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        handleNotification(notification)
        completionHandler([.banner, .sound])
    }

    // Handle notification tap
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
        handleNotification(response.notification)
        completionHandler()
    }

    private func handleNotification(_ notification: UNNotification) {
        let identifier = notification.request.identifier

        // Extract activity type from identifier
        if identifier.starts(with: "daily_reminder_") {
            dataManager?.triggerCheckInBanner(for: .daily)
        } else if identifier == "weekly_luck_reminder" {
            dataManager?.triggerCheckInBanner(for: .weeklyLuck)
        }
    }
}
